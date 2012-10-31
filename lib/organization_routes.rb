class OrganizationRoutes
  def self.matches?(request)
    return true if request.subdomain.present? && request.subdomain != 'www'
  end
end
