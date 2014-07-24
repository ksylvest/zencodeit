class Video < ActiveRecord::Base

  belongs_to :user

  has_one :job, dependent: :destroy
  has_many :outputs, dependent: :destroy

  validates_presence_of :name
  validates_presence_of :description

  scope :active, -> { where(state: 'finished') }

  DEFAULTS = {
    public: 1, speed: 1, quality: 5,
    notifications: [ { format: "json", url: "http://zencodeit.heroku.com/videos/notifications.json" } ]
  }

  OUTPUTS = {
    webm: { label: 'webm', video_codec: 'vp8',    audio_codec: 'vorbis', width: 928, height: 522 },
    mp4:  { label: 'mp4',  video_codec: 'h264',   audio_codec: 'aac',    width: 928, height: 522 },
    ogg:  { label: 'ogg',  video_codec: 'theora', audio_codec: 'vorbis', width: 928, height: 522 },
  }

  has_attached :encoding, path: "videos/encodings/:style/:identifier:extension", styles: {
    webm: { extension: '.webm' },
    mp4:  { extension: '.mp4'  },
    ogg:  { extension: '.ogv'  },
  }

  has_attached :preview, path: "videos/previews/:style/:identifier:extension", processor: :image, styles: {
    poster: { size: "928x522#" },
    :'grid-12' => { size: "928x522#" },
    :'grid-10' => { size: "768x432#" },
    :'grid-08' => { size: "608x342#" },
    :'grid-06' => { size: "448x252#" },
    :'grid-04' => { size: "288x162#" },
  }

  validates_attached_presence :encoding
  validates_attached_size :encoding, in: 0.megabytes..2.gigabytes

  validates_attached_presence :preview
  validates_attached_size :preview, in: 0.megabytes..2.gigabytes
  validates_attached_extension :preview, in: %w(jpe jpg jpeg png)

  def encodings
    [
      self.encoding.url(:webm),
      self.encoding.url(:mp4),
      self.encoding.url(:ogg),
    ]
  end

  def refresh(job, output)
    job.refresh
    job.save

    output.refresh
    output.save

    self.state = job.state || output.state
    self.save
  end

  before_save :zencodeit, if: Proc.new { |video| video.encoding.changed? }

  def zencodeit
    input = self.encoding.url
    outputs = []

    OUTPUTS.each do |style, options|
      output = DEFAULTS
      output = output.merge(options)
      output = output.merge(url: self.encoding.url(style))
      outputs << output
    end

    response = Zencoder::Job.create({ input: input, outputs: outputs })

    self.state = response.success? ? 'processing' : 'failed'

    if response.success?
      self.build_job(zencoder_id: response.body['id'])
      response.body['outputs'].each do |output|
        self.outputs.build(zencoder_id: output['id'])
      end
    end

    return response
  end

end
