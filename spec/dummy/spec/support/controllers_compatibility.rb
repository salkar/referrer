module ControllersCompatibility
  def params(hash)
    Rails::VERSION::MAJOR > 4 ? {params: hash} : hash
  end
end