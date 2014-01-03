class User < ActiveRecord::Base
  before_save :get_ldap_fullname

  # Include default devise modules. Others available are:
  # :token_authenticatable, :confirmable,
  # :lockable, :timeoutable and :omniauthable
  devise :ldap_authenticatable, :rememberable, :trackable

  # Setup accessible (or protected) attributes for your model
  attr_accessible :email, :password, :password_confirmation, :remember_me, :fullname, :send_email
  
  def get_ldap_fullname
     self.fullname = Devise::LdapAdapter.get_ldap_param(self.login, "displayName")
  end
end
