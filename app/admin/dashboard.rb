# encoding: utf-8
ActiveAdmin.register_page "Dashboard" do

  menu :priority => 1, :label => proc{ I18n.t("active_admin.dashboard") }

  sidebar 'Поиск'   do
    find_value=params[:find_value]
    form :action=>'/admin/dashboard',:method=>'get',:class=>'autoreload' do |f|
       label "Значение:"
       f.input  :name=>'find_value', :id=>:dashboard_value, :value=>find_value
    end  
  end    
  content :title => "Справочники" do
    Referencebook.all.each do |referencebook|
        panel "#{referencebook.name}" do
          table do
            tr do 
              referencebook.attribs.each_with_index do |attrib,i|
                th attrib.name
              end  
            end
            
            if params[:find_value].present?
              records=referencebook.find_records(params[:find_value])
            else  
              records=referencebook.records   
            end
            p records 
            records.each do |record|
              tr do 
                record[:attribs].each do |attrib|
                  td attrib[:data]
                end  
              end  
            end
          end
        end
    end    
  end # content
end