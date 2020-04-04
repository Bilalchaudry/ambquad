client_company = ClientCompany.create(company_name: "Ambquad", company_id: "#aq", address: "Lahore",
                                      country_name: "Pakistan", phone: "+92090078601")
User.create(email: 'admin@example.com', username: "admin", password: 'password',
            role: "SuperAdmin", client_company_id: client_company.id)
User.create(email: 'admin@ambquadtm.com', username: "ambquad_admin", password: 'ambQuad2020!',
            role: "SuperAdmin", client_company_id: client_company.id)