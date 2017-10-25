class AwardEmoji < ActiveRecord::Base
  DOWNVOTE_NAME = "thumbsdown".freeze
  UPVOTE_NAME   = "thumbsup".freeze

  include Participable
  include GhostUser

  belongs_to :awardable, polymorphic: true # rubocop:disable Cop/PolymorphicAssociations
  belongs_to :user

  validates :awardable, :user, presence: true
  validates :name, presence: true
  validates :name, uniqueness: { scope: [:user, :awardable_type, :awardable_id] }, unless: :ghost_user?

  validate :valid_emoji_name

  participant :user

  scope :downvotes, -> { where(name: DOWNVOTE_NAME) }
  scope :upvotes,   -> { where(name: UPVOTE_NAME) }

  after_save :expire_etag_cache
  after_destroy :expire_etag_cache

  class << self
    def votes_for_collection(ids, type)
      select('name', 'awardable_id', 'COUNT(*) as count')
        .where('name IN (?) AND awardable_type = ? AND awardable_id IN (?)', [DOWNVOTE_NAME, UPVOTE_NAME], type, ids)
        .group('name', 'awardable_id')
    end
  end

  def downvote?
    self.name == DOWNVOTE_NAME
  end

  def upvote?
    self.name == UPVOTE_NAME
  end

  def expire_etag_cache
    awardable.try(:expire_etag_cache)
  end

  private

  def namespace
    awardable.project.namespace || awardable.author.namespace
  end

  def valid_emoji_name
    valid_emoji = Gitlab::Emoji.emojis_names
    valid_emoji += namespace.custom_emoji_url_by_name.keys

    self.errors.add(:name, 'invalid emoji name') unless valid_emoji.include?(name)
  end
end
