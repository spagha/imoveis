class UsuariosController < InheritedResources::Base
   before_filter :require_user#_and_tipo
    

  def new
     @lista_empresas = Empresa.find(:all)
	
     new!
  end
  
  def index
    unless session[:empresa_atual].nil?
    @usuarios_da_empresa = Usuario.find_all_by_empresa_id(session[:empresa_atual])
    else
    @usuarios_da_empresa = Usuario.find_all_by_empresa_id(@current_usuario.empresa_id)
    end 
    index!
  end
  
  def edit
    @lista_empresas = Empresa.find(:all)
	
    edit!
  end  

  def create
    create! { usuarios_path }
	
  end
  
  def update
    update! { usuarios_path }
  end
  
end
