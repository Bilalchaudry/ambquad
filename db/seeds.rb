client_company = ClientCompany.create(company_name: "Ambquad", company_id: "#aq", address: "Lahore",
                                      country_name: "Pakistan", phone: "+92090078601")
User.create(email: 'admin@example.com', username: "admin", password: 'password',
            role: "Admin", client_company_id: client_company.id, email_confirmed: true,
            confirmed_at: Time.now, status: 0)
User.create(email: 'admin@ambquadtm.com', username: "ambquad_admin", password: 'ambQuad2020!',
            role: "Admin", client_company_id: client_company.id, email_confirmed: true,
            confirmed_at: Time.now, status: 0)

TemporaryUser.create(email: 'admin@example.com', username: "admin", password: 'password',
            role: 0, client_company_id: client_company.id, email_confirmed: true, status: 0)

TemporaryUser.create(email: 'admin@ambquadtm.com', username: "ambquad_admin", password: 'ambQuad2020!',
            role: 0, client_company_id: client_company.id, email_confirmed: true, status: 0)