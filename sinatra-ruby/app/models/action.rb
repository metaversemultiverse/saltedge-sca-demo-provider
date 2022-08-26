#
# @author Daniel Marcenco (danielm@saltedge.com)
# Copyright (c) 2022 Salt Edge.
#

class Action < ActiveRecord::Base
  STATUSES = %w[pending confirm_processing deny_processing confirmed denied closed additional].freeze.each do |name|
    const_set(name.upcase, name)
  end

  def active?
    %w[pending confirm_processing deny_processing].include?(status)
  end

  def closed?
    !active?
  end

  def expires_at
    created_at + 10 * 60 # Add 10 minutes from creation
  end

  def expired?
    expires_at.utc < Time.now.utc
  end

  def inactive?
    closed? || expired?
  end

  def created_at_description
    created_at.strftime('yyyy-MM-dd HH:mm:ss')
  end

  def parsed_authorizations
    authorizations.present? ? JSON.parse(authorizations) : []
  end
end
