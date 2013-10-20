class ClientesController < InheritedResources::Base
  respond_to :html, :js
  before_filter :require_user
  before_filter :clientes_da_empresa

  def clientes_da_empresa
    if session[:empresa_atual]
    	if @current_usuario.tipo == "Vendedor"
    	  @clientes_da_empresa = Cliente.find_all_by_empresa_id_and_usuario_id(session[:empresa_atual].id, @current_usuario.id)
    	else
	      @clientes_da_empresa = Cliente.find_all_by_empresa_id(session[:empresa_atual].id)
	    end
    else
    	if @current_usuario.tipo == "Vendedor"
    	  @clientes_da_empresa = Cliente.find_all_by_empresa_id_and_usuario_id(@current_usuario.empresa_id, @current_usuario.id)
    	else
    	  @clientes_da_empresa = Cliente.find_all_by_empresa_id(@current_usuario.empresa_id)
    	end
    end


  end

  def index
  end

  def destroy
    destroy! do |success, failure|
      success.js
      failure.js { render 'errors.js.erb' }

    end
    clientes_da_empresa
  end

  def create

    create! do |success, failure|
      failure.js   { render 'errors.js.erb' }
      success.js { respond_with @cliente }
    end

  end

  def define_negociacao
    unless session[:negociacao].nil?
    @negociacao = session[:negociacao]
    end
  end


 def show
   define_negociacao
   @cliente = Cliente.find(params[:id])
   @historicos = @cliente.historico_de_contatos
   puts @historicos
   puts "-----------"
   puts @cliente

   if @historicos.nil?
     @historicos = []
   end
   respond_to do |format|
      format.html # show.html.erb
      format.js
    end
 end

 def seleciona_negociacao
   session[:negociacao] = HistoricoDeContato.find(params[:id])
   @negociacao = session[:negociacao]

   respond_to do |format|
     format.js
   end

 end

end
