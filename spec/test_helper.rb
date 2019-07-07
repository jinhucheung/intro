module TestHelper
  def revert_intro_config(&block)
    clone = Intro.config.clone

    instance_exec(&block)

    Intro.instance_variable_set(:@config, clone)
  end
end