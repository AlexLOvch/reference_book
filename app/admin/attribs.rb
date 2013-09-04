# encoding: utf-8
ActiveAdmin.register Attrib do
  menu :priority => 2

  index do
    column :referencebook
    column :name
    column :data_type
    default_actions
  end    

  form do |f|
    f.inputs "Справочник" do
      f.input :referencebook
      f.input :name, :required => true
      f.input :data_type, :required => true, as: :select, :collection => options_for_select( DATA_TYPES.map{ |r| [r,  r]} , :selected=> attrib.new_record? ? '': attrib.data_type)
    end
    f.buttons
  end   




  controller do
    def create
      if  redirect_after_to=params[:attrib][:redirect_after]
        params[:attrib].delete(:redirect_after)
        Attrib.create(params[:attrib])
        redirect_to redirect_after_to if redirect_after_to
      else 
       super
      end   
    end

    def update
      if  redirect_after_to=params[:attrib][:redirect_after]
        params[:attrib].delete(:redirect_after)
        
        @attrib = Attrib.find(params[:id])
        if @attrib.update_attributes(params[:attrib])
          redirect_to redirect_after_to if redirect_after_to
        end

      else 
       super
      end   
    end


    def destroy
      if  redirect_after_to=params[:redirect_after]
        #params[:attrib].delete(:redirect_after)
        Attrib.destroy(params[:id])
        redirect_to redirect_after_to if redirect_after_to
      else 
       super
      end   
    end
  end
  
end
