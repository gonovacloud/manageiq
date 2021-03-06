#
# Rest API Request Tests - Providers specs
#
# - Creating a provider                   /api/providers                        POST
# - Creating a provider via action        /api/providers                        action "create"
# - Creating multiple providers           /api/providers                        action "create"
# - Edit a provider                       /api/providers/:id                    action "edit"
# - Edit multiple providers               /api/providers                        action "edit"
# - Delete a provider                     /api/providers/:id                    DELETE
# - Delete a provider by action           /api/providers/:id                    action "delete"
# - Delete multiple providers             /api/providers                        action "delete"
#
# - Refresh a provider                    /api/providers/:id                    action "refresh"
# - Refresh multiple providers            /api/providers                        action "refresh"
#
describe "Providers API" do
  ENDPOINT_ATTRS = Api::ProvidersController::ENDPOINT_ATTRS

  let(:default_credentials) { {"userid" => "admin1", "password" => "password1"} }
  let(:metrics_credentials) { {"userid" => "admin2", "password" => "password2", "auth_type" => "metrics"} }
  let(:compound_credentials) { [default_credentials, metrics_credentials] }
  let(:openshift_credentials) do
    {
      "auth_type" => "bearer",
      "auth_key"  => SecureRandom.hex
    }
  end
  let(:sample_vmware) do
    {
      "type"      => "NOVAHawk::Providers::Vmware::InfraManager",
      "name"      => "sample vmware",
      "hostname"  => "sample_vmware.provider.com",
      "ipaddress" => "100.200.300.1"
    }
  end
  let(:sample_rhevm) do
    {
      "type"              => "NOVAHawk::Providers::Redhat::InfraManager",
      "name"              => "sample rhevm",
      "port"              => 5000,
      "hostname"          => "sample_rhevm.provider.com",
      "ipaddress"         => "100.200.300.2",
      'security_protocol' => 'kerberos',
    }
  end
  let(:sample_openshift) do
    {
      "type"              => "NOVAHawk::Providers::Openshift::ContainerManager",
      "name"              => "sample openshift",
      "port"              => 8443,
      "hostname"          => "sample_openshift.provider.com",
      "ipaddress"         => "100.200.300.3",
      'security_protocol' => 'kerberos',
    }
  end
  let(:default_connection) do
    {
      "endpoint"       => {
        "role"     => "default",
        "hostname" => "sample_openshift_multi_end_point.provider.com",
        "port"     => 8444
      },
      "authentication" => {
        "role"     => "bearer",
        "auth_key" => SecureRandom.hex
      }
    }
  end
  let(:updated_connection) do
    {
      "endpoint"       => {
        "role"     => "default",
        "hostname" => "sample_openshift_multi_end_point.provider.com",
        "port"     => "8443"
      },
      "authentication" => {
        "role"     => "bearer",
        "auth_key" => SecureRandom.hex
      }
    }
  end
  let(:hawkular_connection) do
    {
      "endpoint"       => {
        "role"     => "hawkular",
        "hostname" => "sample_openshift_multi_end_point.provider.com",
        "port"     => "443"
      },
      "authentication" => {
        "role"     => "hawkular",
        "auth_key" => SecureRandom.hex
      }
    }
  end
  let(:sample_openshift_multi_end_point) do
    {
      "type"                      => "NOVAHawk::Providers::Openshift::ContainerManager",
      "name"                      => "sample openshift with multiple endpoints",
      "connection_configurations" => [default_connection, hawkular_connection]
    }
  end

  context "Provider custom_attributes" do
    let(:provider) { FactoryGirl.create(:ext_management_system, sample_rhevm) }
    let(:provider_url) { providers_url(provider.id) }
    let(:ca1) { FactoryGirl.create(:custom_attribute, :name => "name1", :value => "value1") }
    let(:ca2) { FactoryGirl.create(:custom_attribute, :name => "name2", :value => "value2") }
    let(:provider_ca_url) { "#{provider_url}/custom_attributes" }
    let(:ca1_url) { "#{provider_ca_url}/#{ca1.id}" }
    let(:ca2_url) { "#{provider_ca_url}/#{ca2.id}" }
    let(:provider_ca_url_list) { [ca1_url, ca2_url] }

    it "getting custom_attributes from a provider with no custom_attributes" do
      api_basic_authorize

      run_get(provider_ca_url)

      expect_empty_query_result(:custom_attributes)
    end

    it "getting custom_attributes from a provider" do
      api_basic_authorize
      provider.custom_attributes = [ca1, ca2]

      run_get provider_ca_url

      expect_query_result(:custom_attributes, 2)

      expect_result_resources_to_include_hrefs("resources", provider_ca_url_list)
    end

    it "getting custom_attributes from a provider in expanded form" do
      api_basic_authorize
      provider.custom_attributes = [ca1, ca2]

      run_get provider_ca_url, :expand => "resources"

      expect_query_result(:custom_attributes, 2)

      expect_result_resources_to_include_data("resources", "name" => %w(name1 name2))
    end

    it "getting custom_attributes from a provider using expand" do
      api_basic_authorize action_identifier(:providers, :read, :resource_actions, :get)
      provider.custom_attributes = [ca1, ca2]

      run_get provider_url, :expand => "custom_attributes"

      expect_single_resource_query("guid" => provider.guid)

      expect_result_resources_to_include_data("custom_attributes", "name" => %w(name1 name2))
    end

    it "delete a custom_attribute without appropriate role" do
      api_basic_authorize
      provider.custom_attributes = [ca1]

      run_post(provider_ca_url, gen_request(:delete, nil, provider_url))

      expect(response).to have_http_status(:forbidden)
    end

    it "delete a custom_attribute from a provider via the delete action" do
      api_basic_authorize action_identifier(:providers, :edit)
      provider.custom_attributes = [ca1]

      run_post(provider_ca_url, gen_request(:delete, nil, ca1_url))

      expect(response).to have_http_status(:ok)

      expect(provider.reload.custom_attributes).to be_empty
    end

    it "add custom attribute to a provider without a name" do
      api_basic_authorize action_identifier(:providers, :edit)

      run_post(provider_ca_url, gen_request(:add, "value" => "value1"))

      expect_bad_request("Must specify a name")
    end

    it "prevents adding custom attribute to a provider with forbidden section" do
      api_basic_authorize action_identifier(:providers, :edit)

      run_post(provider_ca_url, gen_request(:add, [{"name" => "name3", "value" => "value3",
                                                    "section" => "bad_section"}]))

      expect_bad_request("Invalid provider custom attributes specified - " \
                         "Invalid attribute section specified: bad_section")
    end

    it "add custom attributes to a provider" do
      api_basic_authorize action_identifier(:providers, :edit)

      run_post(provider_ca_url, gen_request(:add, [{"name" => "name1", "value" => "value1"},
                                                   {"name" => "name2", "value" => "value2", "section" => "metadata"}]))
      expected = {
        "results" => a_collection_containing_exactly(
          a_hash_including("name" => "name1", "value" => "value1", "section" => "metadata"),
          a_hash_including("name" => "name2", "value" => "value2", "section" => "metadata")
        )
      }
      expect(response).to have_http_status(:ok)

      expect(response.parsed_body).to include(expected)

      expect(provider.custom_attributes.size).to eq(2)
    end

    it "formats custom attribute of type date" do
      api_basic_authorize action_identifier(:providers, :edit)
      date_field = DateTime.new.in_time_zone

      run_post(provider_ca_url, gen_request(:add, [{"name"       => "name1",
                                                    "value"      => date_field,
                                                    "field_type" => "DateTime"}]))

      expect(response).to have_http_status(:ok)

      expect(provider.custom_attributes.first.serialized_value).to eq(date_field)

      expect(provider.custom_attributes.first.section).to eq("metadata")
    end

    it "edit a custom attribute by name" do
      api_basic_authorize action_identifier(:providers, :edit)
      provider.custom_attributes = [ca1]

      run_post(provider_ca_url, gen_request(:edit, "name" => "name1", "value" => "value one"))

      expect(response).to have_http_status(:ok)

      expect_result_resources_to_include_data("results", "value" => ["value one"])

      expect(provider.reload.custom_attributes.first.value).to eq("value one")
    end
  end

  describe "Providers actions on Provider class" do
    let(:foreman_type) { NOVAHawk::Providers::Foreman::Provider }
    let(:sample_foreman) do
      {
        :name        => 'my-foreman',
        :type        => foreman_type.to_s,
        :credentials => {:userid => 'admin', :password => 'changeme'},
        :url         => 'https://foreman.example.com'
      }
    end

    it "rejects requests with invalid provider_class" do
      api_basic_authorize

      run_get providers_url, :provider_class => "bad_class"

      expect_bad_request(/unsupported/i)
    end

    it "supports requests with valid provider_class" do
      api_basic_authorize collection_action_identifier(:providers, :read, :get)

      FactoryGirl.build(:provider_foreman)
      run_get providers_url, :provider_class => "provider", :expand => "resources"

      klass = Provider
      expect_query_result(:providers, klass.count, klass.count)
      expect_result_resources_to_include_data("resources", "name" => klass.pluck(:name))
    end

    it 'creates valid foreman provider' do
      api_basic_authorize collection_action_identifier(:providers, :create)

      # TODO: provider_class in params, when supported (https://github.com/brynary/rack-test/issues/150)
      run_post(providers_url + '?provider_class=provider', gen_request(:create, sample_foreman))

      expect(response).to have_http_status(:ok)

      provider_id = response.parsed_body["results"].first["id"]
      expect(foreman_type.exists?(provider_id)).to be_truthy
      provider = foreman_type.find(provider_id)
      [:name, :type, :url].each do |item|
        expect(provider.send(item)).to eq(sample_foreman[item])
      end
    end
  end

  describe "Providers create" do
    it "rejects creation without appropriate role" do
      api_basic_authorize

      run_post(providers_url, sample_rhevm)

      expect(response).to have_http_status(:forbidden)
    end

    it "rejects provider creation with id specified" do
      api_basic_authorize collection_action_identifier(:providers, :create)

      run_post(providers_url, "name" => "sample provider", "id" => 100)

      expect_bad_request(/id or href should not be specified/i)
    end

    it "rejects provider creation with invalid type specified" do
      api_basic_authorize collection_action_identifier(:providers, :create)

      run_post(providers_url, "name" => "sample provider", "type" => "BogusType")

      expect_bad_request(/Invalid provider type BogusType/i)
    end

    it "supports single provider creation" do
      api_basic_authorize collection_action_identifier(:providers, :create)

      run_post(providers_url, sample_rhevm)

      expect(response).to have_http_status(:ok)
      expected = {
        "results" => [
          a_hash_including({"id" => kind_of(Integer)}.merge(sample_rhevm.except(*ENDPOINT_ATTRS)))
        ]
      }
      expect(response.parsed_body).to include(expected)

      provider_id = response.parsed_body["results"].first["id"]
      expect(ExtManagementSystem.exists?(provider_id)).to be_truthy
      endpoint = ExtManagementSystem.find(provider_id).default_endpoint
      expect_result_to_match_hash(endpoint.attributes, sample_rhevm.slice(*ENDPOINT_ATTRS))
    end

    it "supports openshift creation with auth_key specified" do
      api_basic_authorize collection_action_identifier(:providers, :create)

      run_post(providers_url, sample_openshift.merge("credentials" => [openshift_credentials]))

      expect(response).to have_http_status(:ok)
      expected = {
        "results" => [
          a_hash_including({"id" => kind_of(Integer)}.merge(sample_openshift.except(*ENDPOINT_ATTRS)))
        ]
      }
      expect(response.parsed_body).to include(expected)

      provider_id = response.parsed_body["results"].first["id"]
      expect(ExtManagementSystem.exists?(provider_id)).to be_truthy
      ems = ExtManagementSystem.find(provider_id)
      expect(ems.authentications.size).to eq(1)
      ENDPOINT_ATTRS.each do |attr|
        expect(ems.send(attr)).to eq(sample_openshift[attr]) if sample_openshift.key? attr
      end
    end

    it "supports single provider creation via action" do
      api_basic_authorize collection_action_identifier(:providers, :create)

      run_post(providers_url, gen_request(:create, sample_rhevm))

      expect(response).to have_http_status(:ok)
      expected = {
        "results" => [
          a_hash_including({"id" => kind_of(Integer)}.merge(sample_rhevm.except(*ENDPOINT_ATTRS)))
        ]
      }
      expect(response.parsed_body).to include(expected)

      provider_id = response.parsed_body["results"].first["id"]
      expect(ExtManagementSystem.exists?(provider_id)).to be_truthy
    end

    it "supports single provider creation with simple credentials" do
      api_basic_authorize collection_action_identifier(:providers, :create)

      run_post(providers_url, sample_vmware.merge("credentials" => default_credentials))

      expect(response).to have_http_status(:ok)
      expected = {
        "results" => [
          a_hash_including({"id" => kind_of(Integer)}.merge(sample_vmware.except(*ENDPOINT_ATTRS)))
        ]
      }
      expect(response.parsed_body).to include(expected)

      provider_id = response.parsed_body["results"].first["id"]
      expect(ExtManagementSystem.exists?(provider_id)).to be_truthy
      provider = ExtManagementSystem.find(provider_id)
      expect(provider.authentication_userid).to eq(default_credentials["userid"])
      expect(provider.authentication_password).to eq(default_credentials["password"])
    end

    it "supports single provider creation with compound credentials" do
      api_basic_authorize collection_action_identifier(:providers, :create)

      run_post(providers_url, sample_rhevm.merge("credentials" => compound_credentials))

      expect(response).to have_http_status(:ok)
      expected = {
        "results" => [
          a_hash_including({"id" => kind_of(Integer)}.merge(sample_rhevm.except(*ENDPOINT_ATTRS)))
        ]
      }
      expect(response.parsed_body).to include(expected)

      provider_id = response.parsed_body["results"].first["id"]
      expect(ExtManagementSystem.exists?(provider_id)).to be_truthy
      provider = ExtManagementSystem.find(provider_id)
      expect(provider.authentication_userid(:default)).to eq(default_credentials["userid"])
      expect(provider.authentication_password(:default)).to eq(default_credentials["password"])
      expect(provider.authentication_userid(:metrics)).to eq(metrics_credentials["userid"])
      expect(provider.authentication_password(:metrics)).to eq(metrics_credentials["password"])
    end

    it "supports multiple provider creation" do
      api_basic_authorize collection_action_identifier(:providers, :create)

      run_post(providers_url, gen_request(:create, [sample_vmware, sample_rhevm]))

      expect(response).to have_http_status(:ok)
      expected = {
        "results" => a_collection_containing_exactly(
          a_hash_including({"id" => kind_of(Integer)}.merge(sample_vmware.except(*ENDPOINT_ATTRS))),
          a_hash_including({"id" => kind_of(Integer)}.merge(sample_rhevm.except(*ENDPOINT_ATTRS)))
        )
      }
      expect(response.parsed_body).to include(expected)

      results = response.parsed_body["results"]
      p1_id, p2_id = results.first["id"], results.second["id"]
      expect(ExtManagementSystem.exists?(p1_id)).to be_truthy
      expect(ExtManagementSystem.exists?(p2_id)).to be_truthy
    end

    it "supports provider with multiple endpoints creation" do
      def hostname(connection)
        connection["endpoint"]["hostname"]
      end

      def port(connection)
        connection["endpoint"]["port"]
      end

      def token(connection)
        connection["authentication"]["auth_key"]
      end

      api_basic_authorize collection_action_identifier(:providers, :create)

      run_post(providers_url, gen_request(:create, sample_openshift_multi_end_point))

      expect(response).to have_http_status(:ok)
      expected = {"id"   => a_kind_of(Integer),
                  "type" => "NOVAHawk::Providers::Openshift::ContainerManager",
                  "name" => "sample openshift with multiple endpoints"}
      results = response.parsed_body["results"]
      expect(results.first).to include(expected)

      provider_id = results.first["id"]
      expect(ExtManagementSystem.exists?(provider_id)).to be_truthy
      provider = ExtManagementSystem.find(provider_id)

      expect(provider.hostname).to eq(hostname(default_connection))
      expect(provider.authentication_token).to eq(token(default_connection))
      expect(provider.port).to eq(port(default_connection))
      expect(provider.connection_configurations.hawkular.endpoint.hostname).to eq(hostname(hawkular_connection))
      expect(provider.connection_configurations.hawkular.authentication.auth_key).to eq(token(hawkular_connection))
    end
  end

  describe "Providers edit" do
    it "rejects resource edits without appropriate role" do
      api_basic_authorize

      run_post(providers_url, gen_request(:edit, "name" => "provider name", "href" => providers_url(999_999)))

      expect(response).to have_http_status(:forbidden)
    end

    it "rejects edits for invalid resources" do
      api_basic_authorize collection_action_identifier(:providers, :edit)

      run_post(providers_url(999_999), gen_request(:edit, "name" => "updated provider name"))

      expect(response).to have_http_status(:not_found)
    end

    it "supports single resource edit" do
      api_basic_authorize collection_action_identifier(:providers, :edit)

      provider = FactoryGirl.create(:ext_management_system, sample_rhevm)

      run_post(providers_url(provider.id), gen_request(:edit, "name" => "updated provider", "port" => "8080"))

      expect_single_resource_query("id" => provider.id, "name" => "updated provider")
      expect(provider.reload.name).to eq("updated provider")
      expect(provider.port).to eq(8080)
    end

    it "only returns real attributes" do
      api_basic_authorize collection_action_identifier(:providers, :edit)

      provider = FactoryGirl.create(:ext_management_system, sample_rhevm)

      run_post(providers_url(provider.id), gen_request(:edit, "name" => "updated provider", "port" => "8080"))

      response_keys = response.parsed_body.keys
      expect(response_keys).to include("tenant_id")
      expect(response_keys).not_to include("total_vms")
    end

    it "supports updates of credentials" do
      api_basic_authorize collection_action_identifier(:providers, :edit)

      provider = FactoryGirl.create(:ext_management_system, sample_vmware)
      provider.update_authentication(:default => default_credentials.symbolize_keys)

      run_post(providers_url(provider.id), gen_request(:edit,
                                                       "name"        => "updated vmware",
                                                       "credentials" => {"userid" => "superadmin"}))

      expect_single_resource_query("id" => provider.id, "name" => "updated vmware")
      expect(provider.reload.name).to eq("updated vmware")
      expect(provider.authentication_userid).to eq("superadmin")
    end

    it "does not schedule a new credentials check if endpoint does not change" do
      api_basic_authorize collection_action_identifier(:providers, :edit)

      provider = FactoryGirl.create(:ext_management_system, sample_openshift_multi_end_point)
      MiqQueue.where(:method_name => "authentication_check_types",
                     :class_name  => "ExtManagementSystem",
                     :instance_id => provider.id).delete_all

      run_post(providers_url(provider.id), gen_request(:edit,
                                                       "connection_configurations" => [default_connection,
                                                                                       hawkular_connection]))

      queue_jobs = MiqQueue.where(:method_name => "authentication_check_types",
                                  :class_name  => "ExtManagementSystem",
                                  :instance_id => provider.id)
      expect(queue_jobs).to be
      expect(queue_jobs.length).to eq(0)
    end

    it "schedules a new credentials check if endpoint change" do
      api_basic_authorize collection_action_identifier(:providers, :edit)

      provider = FactoryGirl.create(:ext_management_system, sample_openshift_multi_end_point)
      MiqQueue.where(:method_name => "authentication_check_types",
                     :class_name  => "ExtManagementSystem",
                     :instance_id => provider.id).delete_all

      run_post(providers_url(provider.id), gen_request(:edit,
                                                       "connection_configurations" => [updated_connection,
                                                                                       hawkular_connection]))

      queue_jobs = MiqQueue.where(:method_name => "authentication_check_types",
                                  :class_name  => "ExtManagementSystem",
                                  :instance_id => provider.id)
      expect(queue_jobs).to be
      expect(queue_jobs.length).to eq(1)
      expect(queue_jobs[0].args[0][0]).to eq(:bearer)
    end

    it "supports additions of credentials" do
      api_basic_authorize collection_action_identifier(:providers, :edit)

      provider = FactoryGirl.create(:ext_management_system, sample_rhevm)
      provider.update_authentication(:default => default_credentials.symbolize_keys)

      run_post(providers_url(provider.id), gen_request(:edit,
                                                       "name"        => "updated rhevm",
                                                       "credentials" => [metrics_credentials]))

      expect_single_resource_query("id" => provider.id, "name" => "updated rhevm")
      expect(provider.reload.name).to eq("updated rhevm")
      expect(provider.authentication_userid).to eq(default_credentials["userid"])
      expect(provider.authentication_userid(:metrics)).to eq(metrics_credentials["userid"])
    end

    it "supports multiple resource edits" do
      api_basic_authorize collection_action_identifier(:providers, :edit)

      p1 = FactoryGirl.create(:ems_redhat, :name => "name1")
      p2 = FactoryGirl.create(:ems_redhat, :name => "name2")

      run_post(providers_url, gen_request(:edit,
                                          [{"href" => providers_url(p1.id), "name" => "updated name1"},
                                           {"href" => providers_url(p2.id), "name" => "updated name2"}]))

      expect_results_to_match_hash("results",
                                   [{"id" => p1.id, "name" => "updated name1"},
                                    {"id" => p2.id, "name" => "updated name2"}])

      expect(p1.reload.name).to eq("updated name1")
      expect(p2.reload.name).to eq("updated name2")
    end
  end

  describe "Providers delete" do
    it "rejects deletion without appropriate role" do
      api_basic_authorize

      run_post(providers_url, gen_request(:delete, "name" => "provider name", "href" => providers_url(100)))

      expect(response).to have_http_status(:forbidden)
    end

    it "rejects deletion without appropriate role" do
      api_basic_authorize

      run_delete(providers_url(100))

      expect(response).to have_http_status(:forbidden)
    end

    it "rejects deletes for invalid providers" do
      api_basic_authorize collection_action_identifier(:providers, :delete)

      run_delete(providers_url(999_999))

      expect(response).to have_http_status(:not_found)
    end

    it "supports single provider delete" do
      api_basic_authorize collection_action_identifier(:providers, :delete)

      provider = FactoryGirl.create(:ext_management_system, :name => "provider", :hostname => "provider.com")

      run_delete(providers_url(provider.id))

      expect(response).to have_http_status(:no_content)
    end

    it "supports single provider delete action" do
      api_basic_authorize collection_action_identifier(:providers, :delete)

      provider = FactoryGirl.create(:ext_management_system, :name => "provider", :hostname => "provider.com")

      run_post(providers_url(provider.id), gen_request(:delete))

      expect_single_action_result(:success => true,
                                  :message => "deleting",
                                  :href    => providers_url(provider.id),
                                  :task    => true)
    end

    it "supports multiple provider deletes" do
      api_basic_authorize collection_action_identifier(:providers, :delete)

      p1 = FactoryGirl.create(:ext_management_system, :name => "provider name 1")
      p2 = FactoryGirl.create(:ext_management_system, :name => "provider name 2")

      run_post(providers_url, gen_request(:delete,
                                          [{"href" => providers_url(p1.id)},
                                           {"href" => providers_url(p2.id)}]))

      expect_multiple_action_result(2, :task => true)
      expect_result_resources_to_include_hrefs("results", [providers_url(p1.id), providers_url(p2.id)])
    end
  end

  describe "Providers refresh" do
    def failed_auth_action(id)
      {"success" => false, "message" => /failed last authentication check/i, "href" => providers_url(id)}
    end

    it "rejects refresh requests without appropriate role" do
      api_basic_authorize

      run_post(providers_url(100), gen_request(:refresh))

      expect(response).to have_http_status(:forbidden)
    end

    it "supports single provider refresh" do
      api_basic_authorize collection_action_identifier(:providers, :refresh)

      provider = FactoryGirl.create(:ext_management_system, sample_vmware.symbolize_keys.except(:type))
      provider.update_authentication(:default => default_credentials.symbolize_keys)

      run_post(providers_url(provider.id), gen_request(:refresh))

      expect_single_action_result(failed_auth_action(provider.id).symbolize_keys)
    end

    it "supports multiple provider refreshes" do
      api_basic_authorize collection_action_identifier(:providers, :refresh)

      p1 = FactoryGirl.create(:ext_management_system, sample_vmware.symbolize_keys.except(:type))
      p1.update_authentication(:default => default_credentials.symbolize_keys)

      p2 = FactoryGirl.create(:ext_management_system, sample_rhevm.symbolize_keys.except(:type))
      p2.update_authentication(:default => default_credentials.symbolize_keys)

      run_post(providers_url, gen_request(:refresh, [{"href" => providers_url(p1.id)},
                                                     {"href" => providers_url(p2.id)}]))
      expect(response).to have_http_status(:ok)
      expect_results_to_match_hash("results", [failed_auth_action(p1.id), failed_auth_action(p2.id)])
    end
  end

  describe 'query Providers' do
    describe 'query custom_attributes' do
      let!(:generic_provider) { FactoryGirl.create(:provider) }
      it 'does not blow-up on provider without custom_attributes' do
        api_basic_authorize collection_action_identifier(:providers, :read, :get)
        run_get(providers_url, :expand => 'resources,custom_attributes', :provider_class => 'provider')
        expect_query_result(:providers, 1, 1)
      end
    end

    context 'provider_class=provider' do
      it 'returns the correct href reference on the collection' do
        provider = FactoryGirl.create(:provider_foreman)
        api_basic_authorize collection_action_identifier(:providers, :read, :get)

        run_get providers_url, :provider_class => 'provider'

        expected = {
          'resources' => [{'href' => a_string_including("/api/providers/#{provider.id}?provider_class=provider")}],
          'actions'   => [a_hash_including('href' => a_string_including('?provider_class=provider'))]
        }
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to include(expected)
      end

      it 'returns the correct href reference on a resource' do
        provider = FactoryGirl.create(:provider_foreman)
        api_basic_authorize action_identifier(:providers, :read, :resource_actions, :get),
                            action_identifier(:providers, :edit)

        run_get providers_url(provider.id), :provider_class => :provider

        expected = {
          'href'    => a_string_including("/api/providers/#{provider.id}?provider_class=provider"),
          'actions' => [
            a_hash_including('href' => a_string_including("/api/providers/#{provider.id}?provider_class=provider"))
          ]
        }
        expect(response).to have_http_status(:ok)
        expect(response.parsed_body).to include(expected)
      end
    end
  end

  describe 'edit custom_attributes on providers' do
    context 'provider_class=provider' do
      let(:generic_provider) { FactoryGirl.create(:provider) }
      let(:attr) { FactoryGirl.create(:custom_attribute) }
      let(:url) do
        # TODO: provider_class in params, when supported (https://github.com/brynary/rack-test/issues/150)
        providers_url(generic_provider.id) + '/custom_attributes' + '?provider_class=provider'
      end

      it 'cannot add a custom_attribute' do
        api_basic_authorize subcollection_action_identifier(:providers, :custom_attributes, :add, :post)
        run_post(url, gen_request(:add, :name => 'x'))
        expect_bad_request("#{generic_provider.class.name} does not support management of custom attributes")
      end

      it 'cannot edit custom_attribute' do
        api_basic_authorize subcollection_action_identifier(:providers, :custom_attributes, :edit, :post)
        run_post(url, gen_request(:edit, :href => custom_attributes_url(attr.id)))
        expect_bad_request("#{generic_provider.class.name} does not support management of custom attributes")
      end
    end
  end
end
