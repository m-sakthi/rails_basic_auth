class Role < ApplicationRecord
  has_and_belongs_to_many :users, :join_table => :users_roles

  belongs_to :resource,
             :polymorphic => true,
             :optional => true

  validates :resource_type,
            :inclusion => { :in => Rolify.resource_types },
            :allow_nil => true

  scopify

  # Define the Privileges
  module Privileges
    ADMIN = 'admin'
    USER = 'user'
    ALL = Role::Privileges.constants.map{ |constant| Role::Privileges.const_get(constant) }.flatten.uniq
  end
end
