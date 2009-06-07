class AccountsController < ApplicationController
  before_filter :require_user
  make_resourceful do
    actions :all
  end
end
