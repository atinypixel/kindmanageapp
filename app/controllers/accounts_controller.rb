class AccountsController < ApplicationController
  before_filter :require_user
end
