# Encoding: UTF-8

include_recipe 'gimp'

gimp_app 'default' do
  action :remove
end
