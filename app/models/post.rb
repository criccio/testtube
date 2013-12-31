class Post < ActiveRecord::Base
  paginates_per 18
  has_attached_file :video,
                    :styles => {:medium => '72x72#',
                                :large => '320x320#'},
                    :processors => lambda { |a| a.video? ? [:video_thumbnail] : [:thumbnail] }

  $supported_formats = %w(application/x-mp4 video/mpeg video/quicktime video/avi video/x-la-asf video/x-ms-asf video/x-ms-wmv video/x-msvideo video/x-sgi-movie video/x-flv flv-application/octet-stream video/3gpp video/3gpp2 video/3gpp-tt video/BMPEG video/BT656 video/CelB video/DV video/H261 video/H263 video/H263-1998 video/H263-2000 video/H264 video/JPEG video/MJ2 video/MP1S video/MP2P video/MP2T video/mp4 video/MP4V-ES video/MPV video/mpeg4 video/mpeg4-generic video/nv video/parityfec video/pointer video/raw video/rtx)

  def video?
    $supported_formats.include?(video.content_type)
  end

  def supported_formats
    $supported_formats
  end

  validates :name, :presence => true
  validates_attachment_presence :video
  validates_attachment_content_type :video, :content_type => $supported_formats

  validates :title, :presence => true,
            :length => {:minimum => 5, :maximum => 45}
  has_many :comments, :dependent => :destroy
  has_many :tags
  has_many :votes, :dependent => :destroy

  accepts_nested_attributes_for :tags, :allow_destroy => :true,
                                :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }
  accepts_nested_attributes_for :votes, :allow_destroy => :true,
                                :reject_if => proc { |attrs| attrs.all? { |k, v| v.blank? } }

  before_post_process :get_video_duration

  def get_video_duration
    result = `ffmpeg -i #{self.video.to_file.path} 2>&1`
    result.force_encoding('ASCII-8BIT')
    r = result.match('Duration: ([0-9]+):([0-9]+):([0-9]+).([0-9]+)')
    if r
      self.duration = r[1].to_i*3600+r[2].to_i*60+r[3].to_i
    end
  end
end
