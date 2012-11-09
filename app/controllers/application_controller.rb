class ApplicationController < ActionController::Base
  protect_from_forgery
  before_filter :authenticate_user!
  before_filter :load_resource
  before_filter :populate_current_user_id

  @@autoload_resource = true

  def self.load_resource_manually
    @@autoload_resource = false
  end

  protected

  def populate_current_user_id
    @current_user_id = current_user.present? ? current_user.id : nil
  end

  def load_resource

    if @@autoload_resource
      begin
        resource_name = controller_name.classify
        resource_decorator_name = "#{resource_name}Decorator"
        id_sym = load_instance? resource_name
        if id_sym
          instance_variable_set("@#{resource_name.underscore}", resource_decorator_name.constantize.find(params[id_sym]))
        elsif build_instance?
          instance_variable_set("@#{resource_name.underscore}", resource_decorator_name.constantize.new)
        elsif load_collection?
          instance_variable_set("@#{resource_name.underscore.pluralize}", resource_decorator_name.constantize.all)
        end
      rescue NameError => ex
        #this isn't a controller that we can get a resource for
      end
    end

  end

  private

  def load_instance? resource_name
    if params.has_key?(:id)
      return :id
    elsif params.has_key?(:"#{resource_name.underscore}_id")
      return :"#{resource_name.underscore}_id"
    end
    false
  end

  def build_instance?
    params[:action] == 'new'
  end

  def load_collection?
    params[:action] == 'index'
  end

end
