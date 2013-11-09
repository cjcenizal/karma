class Notecollection
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Paranoia
  

  has_many :notes

  def notes_count
    self.notes.count
  end

end