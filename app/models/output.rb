class Output < ActiveRecord::Base

  belongs_to :video

  validates_uniqueness_of :zencoder_id

  def refresh
    response = Zencoder::Output.progress(zencoder_id)
    self.state = response.success? ? response.body['state'] : 'failed'
    response
  end

end
