# encoding: utf-8

require 'redmine'

require_dependency 'time_logger_hooks'

# workaround helping rails to find the helper-methods
require File.join(File.dirname(__FILE__), 'app/helpers/application_helper.rb')


Redmine::Plugin.register :time_logger do
    name 'Time Logger'
    author 'Jim McAleer'
    description 'The orignal author was Jérémie Delaitre.'
    url 'https://github.com/speedy32129/time_logger'
    version '0.5.3'


    #fix for contect menus

    requires_redmine :version_or_higher => '1.1.0'

    settings :default => { 'refresh_rate' => '60', 'status_transitions' => {} }, :partial => 'settings/time_logger'

    permission :view_others_time_loggers, :time_loggers => :index
    permission :delete_others_time_loggers, :time_loggers => :delete

    menu :account_menu, :time_logger_menu, '',
        {
            :caption => '',
            :html => { :id => 'time-logger-menu' },
            :first => true,
            :param => :project_id,
            :if => Proc.new { User.current.logged? }
        }
        
    menu :top_menu, :time_loggers, { :controller => :time_loggers, :action => :index }, :caption => 'Time Loggers', :if => Proc.new { TimeLogger.find_by_user_id(User.current)}
    menu :top_menu, :time_loggers_pause, { :controller => :time_loggers, :action => :pause }, :caption => 'Pause #{TimeLogger.find_by_user_id(User.current).issue_id}', :if => Proc.new { !TimeLogger.find_by_user_id(User.current).paused if TimeLogger.find_by_user_id(User.current) 
    menu :top_menu, :time_loggers_resume, { :controller => :time_loggers, :action => :resume }, :caption => 'Resume #{TimeLogger.find_by_user_id(User.current).issue_id}', :if => Proc.new { TimeLogger.find_by_user_id(User.current).paused if TimeLogger.find_by_user_id(User.current) }
    menu :top_menu, :time_loggers_stop, { :controller => :time_loggers, :action => :stop }, :caption => 'Stop #{TimeLogger.find_by_user_id(User.current).issue_id}', :if => Proc.new { !TimeLogger.find_by_user_id(User.current).paused if TimeLogger.find_by_user_id(User.current) }
end
