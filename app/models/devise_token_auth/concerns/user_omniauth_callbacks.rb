# frozen_string_literal: true

module DeviseTokenAuth::Concerns::UserOmniauthCallbacks
  extend ActiveSupport::Concern

  included do
    validates :email, presence: true,if: :email_provider?
    validates :email, email: true, allow_nil: true, allow_blank: true, if: :email_provider?
    validates_presence_of :uuid, unless: :email_provider?

    # only validate unique emails among email registration users
    validates :email, uniqueness: { scope: :provider }, on: :create, if: :email_provider?

    # keep uuid in sync with email
    before_save :sync_uuid
    before_create :sync_uuid
  end

  protected

  def email_provider?
    provider == 'email'
  end

  def sync_uuid
    self.uuid = email if provider == 'email'
  end
end
