@sprockets = Sprockets::Environment.new
@sprockets.append_path @root + '/assets/javascripts'
@sprockets.append_path @root + '/assets/stylesheets'