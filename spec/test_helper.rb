module TestHelper
  def revert_intro_config(&block)
    clone = Intro.config.clone

    instance_exec(&block)

    Intro.instance_variable_set(:@config, clone)
  end

  def random_string
    ('a'..'z').to_a.shuffle.join
  end

  def unauthenticated_path
    Intro.config.unauthenticated_admin_path.presence || new_admin_session_path
  end

  def json_body
    JSON.parse(response.body).with_indifferent_access
  end
end