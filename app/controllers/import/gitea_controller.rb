# frozen_string_literal: true

class Import::GiteaController < Import::GithubController
  def new
    if session[access_token_key].present? && host_url.present?
      redirect_to status_import_url
    end
  end

  def personal_access_token
    session[host_key] = params[host_key]
    super
  end

  def status
    super
  end

  private

  def host_key
    :"#{provider}_host_url"
  end

  # Overridden methods
  def host_url
    session[host_key]
  end

  def provider
    :gitea
  end

  # Gitea is not yet an OAuth provider
  # See https://github.com/go-gitea/gitea/issues/27
  def logged_in_with_provider?
    false
  end

  def provider_auth
    if session[access_token_key].blank? || host_url.blank?
      redirect_to new_import_gitea_url,
        alert: 'You need to specify both an Access Token and a Host URL.'
    end
  end

  def client_options
    { host: host_url, api_version: 'v1' }
  end
end
