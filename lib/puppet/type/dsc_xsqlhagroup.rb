require 'pathname'

Puppet::Type.newtype(:dsc_xsqlhagroup) do
  require Pathname.new(__FILE__).dirname + '../../' + 'puppet/type/base_dsc'
  require Pathname.new(__FILE__).dirname + '../../puppet_x/puppetlabs/dsc_type_helpers'


  @doc = %q{
    The DSC xSqlHAGroup resource type.
    Originally generated from the following schema.mof file:
      import/dsc_resources/xSqlPs/DSCResources/MSFT_xSqlHAGroup/MSFT_xSqlHAGroup.schema.mof
  }

  validate do
      fail('dsc_name is a required attribute') if self[:dsc_name].nil?
    end

  newparam(:dscmeta_resource_friendly_name) do
    defaultto "xSqlHAGroup"
  end

  newparam(:dscmeta_resource_name) do
    defaultto "MSFT_xSqlHAGroup"
  end

  newparam(:dscmeta_import_resource) do
    newvalues(true, false)

    munge do |value|
      PuppetX::Dsc::TypeHelpers.munge_boolean(value.to_s)
    end

    defaultto true
  end

  newparam(:dscmeta_module_name) do
    defaultto "xSqlPs"
  end

  newparam(:dscmeta_module_version) do
    defaultto "1.2.0.0"
  end

  newparam(:name, :namevar => true ) do
  end

  ensurable do
    newvalue(:exists?) { provider.exists? }
    newvalue(:present) { provider.create }
    defaultto { :present }
  end

  # Name:         Name
  # Type:         string
  # IsMandatory:  True
  # Values:       None
  newparam(:dsc_name) do
    def mof_type; 'string' end
    def mof_is_embedded?; false end
    desc "The name of sql availability group"
    isrequired
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         Database
  # Type:         string[]
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_database, :array_matching => :all) do
    def mof_type; 'string[]' end
    def mof_is_embedded?; false end
    desc "Array of databases on the local sql instance. Each database can belong to only one HA group."
    validate do |value|
      unless value.kind_of?(Array) || value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string or an array of strings")
      end
    end
    munge do |value|
      Array(value)
    end
  end

  # Name:         ClusterName
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_clustername) do
    def mof_type; 'string' end
    def mof_is_embedded?; false end
    desc "The name of windows failover cluster for the availability group"
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         DatabaseBackupPath
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_databasebackuppath) do
    def mof_type; 'string' end
    def mof_is_embedded?; false end
    desc "The net share for Sql replication initialization"
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         InstanceName
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_instancename) do
    def mof_type; 'string' end
    def mof_is_embedded?; false end
    desc "Name of sql instance"
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         EndPointName
  # Type:         string
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_endpointname) do
    def mof_type; 'string' end
    def mof_is_embedded?; false end
    desc "Name of EndPoint to access High Availability sql instance."
    validate do |value|
      unless value.kind_of?(String)
        fail("Invalid value '#{value}'. Should be a string")
      end
    end
  end

  # Name:         DomainCredential
  # Type:         MSFT_Credential
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_domaincredential) do
    def mof_type; 'MSFT_Credential' end
    def mof_is_embedded?; true end
    desc "Domain credential could get list of cluster nodes."
    validate do |value|
      unless value.kind_of?(Hash)
        fail("Invalid value '#{value}'. Should be a hash")
      end
      PuppetX::Dsc::TypeHelpers.validate_MSFT_Credential("DomainCredential", value)
    end
  end

  # Name:         SqlAdministratorCredential
  # Type:         MSFT_Credential
  # IsMandatory:  False
  # Values:       None
  newparam(:dsc_sqladministratorcredential) do
    def mof_type; 'MSFT_Credential' end
    def mof_is_embedded?; true end
    desc "Sql sa credential."
    validate do |value|
      unless value.kind_of?(Hash)
        fail("Invalid value '#{value}'. Should be a hash")
      end
      PuppetX::Dsc::TypeHelpers.validate_MSFT_Credential("SqlAdministratorCredential", value)
    end
  end


end

Puppet::Type.type(:dsc_xsqlhagroup).provide :powershell, :parent => Puppet::Type.type(:base_dsc).provider(:powershell) do
  confine :true => (Gem::Version.new(Facter.value(:powershell_version)) >= Gem::Version.new('5.0.10240.16384'))
  defaultfor :operatingsystem => :windows

  mk_resource_methods
end
