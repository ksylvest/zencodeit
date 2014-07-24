class Job < ActiveRecord::Base

  belongs_to :video

  validates_uniqueness_of :zencoder_id

  def refresh
    response = Zencoder::Job.details(self.zencoder_id)
    self.state = response.success? ? response.body['job']['state'] : 'failed'
    return response
  end

end
