require_relative "refresh_spec_common"

describe NOVAHawk::Providers::Openstack::CloudManager::Refresher do
  include Openstack::RefreshSpecCommon

  before(:each) do
    setup_ems('11.22.33.44', 'password_2WpEraURh')
    @environment = :kilo
  end

  it "will perform a full refresh against RHOS #{@environment}" do
    2.times do # Run twice to verify that a second run with existing data does not change anything
      with_cassette(@environment, @ems) do
        EmsRefresh.refresh(@ems)
        EmsRefresh.refresh(@ems.network_manager)
        EmsRefresh.refresh(@ems.cinder_manager)
        EmsRefresh.refresh(@ems.swift_manager)
      end

      assert_common
    end
  end

  context "when configured with skips" do

    it "will not parse the ignored items" do
      with_cassette(@environment, @ems) do
        EmsRefresh.refresh(@ems)
        EmsRefresh.refresh(@ems.network_manager)
        EmsRefresh.refresh(@ems.cinder_manager)
        EmsRefresh.refresh(@ems.swift_manager)
      end

      assert_with_skips
    end
  end

  context "when random 403 and 404 errors occurs" do
    it "refresh will continue" do
      stub_excon_errors

      with_cassette('kilo_with_errors', @ems) do
        EmsRefresh.refresh(@ems)
        EmsRefresh.refresh(@ems.network_manager)
        EmsRefresh.refresh(@ems.cinder_manager)
        EmsRefresh.refresh(@ems.swift_manager)
      end

      assert_with_errors
    end
  end

  context "when using an admin account for fast refresh" do
    it "will perform a fast full legacy refresh against RHOS #{@environment}" do
      ::Settings.ems.ems_openstack.refresh.is_admin = true
      2.times do
        with_cassette("#{@environment}_legacy_fast_refresh", @ems) do
          EmsRefresh.refresh(@ems)
          EmsRefresh.refresh(@ems.network_manager)
          EmsRefresh.refresh(@ems.cinder_manager)
          EmsRefresh.refresh(@ems.swift_manager)
        end
        assert_common
      end
      ::Settings.ems.ems_openstack.refresh.is_admin = false
    end
  end
end
