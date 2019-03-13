title 'Ensure deployed IIS web application MovieApp is up and running.'

iis_app_url = attribute('iis_app_url')

control 'Habitat IIS Application Running' do
  impact 1.0
  title 'Check to see if deployed application MovieApp returns 200 on a GET.'
  describe http(iis_app_url) do
    its('status') { should cmp 200 }
  end
end
