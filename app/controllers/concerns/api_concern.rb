class ApiConcern 
  def initialize

  end
  def crear(params)
    ApiKey.new(params)
  end 
end