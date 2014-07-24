require 'zencoder'

namespace :zencoder do

  desc "Refresh zencoder."
  task refresh: :environment do

    # Refresh jobs.
    Job.all.each do |job|
      next if job.state.eql? 'finished'
      job.refresh
      job.save
    end

    # Refresh outputs.
    Output.all.each do |output|
      next if output.state.eql? 'finished'
      output.refresh
      output.save
    end

    # Refresh videos.
    Video.all.each do |video|
      job = video.job
      video.state = job.state
      video.save
    end

  end

end