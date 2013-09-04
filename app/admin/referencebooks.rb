# encoding: utf-8
ActiveAdmin.register Referencebook do
  config.batch_actions = false
  config.sort_order = "id_asc"

  menu :priority => 1
  filter :name

  index do
    column :name
    default_actions
  end    

  form do |f|
    f.inputs "Справочник" do
      f.input :name, :required => true
    end
    f.buttons
  end   

  show :titile=>proc{"Справочник #{resource.name}"} do
    panel "Аттрибуты" do
      table_for(referencebook.attribs) do |t|
          t.column(:name) 
          t.column(:data_type) 
          t.column "" do |item|
            links = ''.html_safe
            links += link_to icon(:pen_alt_fill),  "#{edit_admin_attrib_path(item.id)}?referencebook_id=#{referencebook.id}&redirect_after=/admin/referencebooks/#{referencebook.id}",  :alt=>I18n.t('active_admin.edit'), :title=>I18n.t('active_admin.edit'), :style=>'font-size:16px'
            links += link_to icon(:x), "#{admin_attrib_path(item.id)}?redirect_after=/admin/referencebooks/#{referencebook.id}", :method => :delete, :confirm => I18n.t('active_admin.delete_confirmation'), :class => "member_link delete_link", :style=>'font-size:16px;margin-left:10px', :alt =>  I18n.t('active_admin.delete'), :title => I18n.t('active_admin.delete')
            links
          end
      end
    end

    panel "Данные" do
      table do
        tr do 
          referencebook.attribs.each_with_index do |attrib,i|
            th attrib.name
          end  
        end
        referencebook.records.each_with_index do |record,i|
          tr do 
            record[:attribs].each do |attrib|
              td attrib[0][:data]
            end  
          end  
        end
      end
    end

  end    

end
