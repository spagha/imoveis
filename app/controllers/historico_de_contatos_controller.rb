class HistoricoDeContatosController < InheritedResources::Base
  before_filter :require_user

  helper_method :define_espaco
  def define_espaco
    puts Espaco.find_by_id(params[:espaco])
    @espaco = Espaco.find_by_id(params[:espaco])

  end

    def simulador

      redirect_to 'simulador'

    end

  def vagas_associadas
    session[:empreendimento_escolhido] = @espaco.empreendimento_id
    #session[:pavimento_escolhido] = @espaco.pavimento_id

    puts "VAGAS NA SESSION DEPOIS QUE VOLTA!!!!!!!!!!!!"
    puts session[:vagas]
    @vaga_associada = VagaAssociada.find_all_by_id_unidade_negociada(@espaco.id)
    puts "VAGAS ASSOCIADAS"
    puts @vaga_associada
    @vaga_associada.each do |vaga|
      (session[:vagas] ||=[]) << vaga.espaco_id.to_s
    end
    if session[:vagas]
    @vagas = session[:vagas]
    else
    @vagas = Array.new
    end


    @vagas_do_empreendimento = Espaco.where(:empreendimento_id => @espaco.empreendimento_id, :tipo_de_espaco => "Garagem", :status => [nil,"0"])
    puts "VAGAS DO EMPREENDIMENTO"
    puts @vagas_do_empreendimento

    unless @vagas_disponiveis
    @vagas_disponiveis = Array.new
    end
    @vagas_do_empreendimento.each do |vaga|
      @vagas_disponiveis << vaga.id.to_s
    end

    unless @vagas_disponiveis_fim
    @vagas_disponiveis_fim = Array.new
    end
    puts "VAGAS DISPONIVEIS"
    puts @vagas_disponiveis
    puts 'vagas da sessao'
    puts @vagas
    @vagas_disponiveis_fim = @vagas_disponiveis - @vagas

    puts 'resultado do baguiu'
    puts @vagas_disponiveis_fim

  end

  def edit
    if @current_usuario.tipo == "Vendedor"
    @clientes = Cliente.find_all_by_empresa_id_and_usuario_id(session[:empresa_atual], @current_usuario.id)
  else
  @clientes = Cliente.find_all_by_empresa_id(session[:empresa_atual])
  end
    @historico_de_contato = HistoricoDeContato.find(params[:id])
    puts "HISTORICO DE CONTATO"
    puts @historico_de_contato.id
    @espaco = Espaco.find_by_id(@historico_de_contato.espaco_id)
    vagas_associadas

    #	@vagas = VagaAssociada.find_all_by_id_unidade_negociada(@espaco.id)

    edit!
  end

  def adiciona_vaga
    puts session[:vagas]
    (session[:vagas] ||=[]) << params[:espaco_id]
    puts "SESSION VAGASSSSS"
    redirect_to (:back)
  end

  def remove_vaga
    session[:vagas].delete(params[:id])
    @vaga_associada = VagaAssociada.find_by_espaco_id(params[:id])
    if @vaga_associada
    @vaga_associada.destroy
    end
    @espaco_vaga = Espaco.find(params[:id])
    @espaco_vaga.status = "0"
    @espaco_vaga.save
    puts "REMOVI VAGA"
    puts session[:vagas]
    redirect_to (:back)
  end

  def new

    define_espaco
    vagas_associadas
    if @current_usuario.tipo == "Vendedor"
    @clientes = Cliente.find_all_by_empresa_id_and_usuario_id(session[:empresa_atual], @current_usuario.id)
	else
	@clientes = Cliente.find_all_by_empresa_id(session[:empresa_atual])
	end
    @vagas_associadas =  @espaco.id
    @vagas_relacionadas = Espaco.find_by_sql "SELECT `espacos`.* FROM `espacos` WHERE `espacos`.`id` IN (SELECT `vaga_associadas`.`espaco_id` FROM `vaga_associadas` WHERE `vaga_associadas`.`id_unidade_negociada` = #@vagas_associadas )"

    @historico_de_contato = HistoricoDeContato.new(:status => "1")
    @historico_de_contato.build_simulacao
    new!

  end

  def show
    @historico_de_contato =  HistoricoDeContato.find_last_by_espaco_id(params[:espaco])
    define_espaco
    session[:vagas] = nil
    vagas_associadas

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @historico_de_contato }
    end

  end

  def update
    update! do | success, failure |
      success.html {redirect_to '/'}
      failure.html {redirect_to :back}
    #  debugger
    end
    p @historico_de_contato.errors if @historico_de_contato.errors.any?
    @historico_de_contato.save
    @espaco_gravado = Espaco.find_by_id(@historico_de_contato.espaco_id)
    @espaco_gravado.status = @historico_de_contato.status
    if @espaco_gravado.update_attributes(params[:espaco_gravado])
    puts "salvou"
    end
    if @espaco_gravado.status == 0
      if session[:vagas]
      @vagas = session[:vagas]
      else
      @vagas = Array.new
      end
      @vagas.each do |vaga|
        @vaga_associada = VagaAssociada.find_by_espaco_id(vaga)
        @espaco_vaga = Espaco.find(vaga)
        @espaco_vaga.status = "0"
        if @espaco_vaga.update_attributes(params[:espaco_vaga])
        puts "salvou"
        end
        @vaga_associada.destroy if @vaga_associada
      end
    else
      @vagas = session[:vagas]
      if @vagas
        @vagas.each do |vaga|
          @vaga_associada = VagaAssociada.new(:espaco_id => vaga, :id_unidade_negociada => @historico_de_contato.espaco_id)
          @espaco_vaga = Espaco.find(vaga)
          @espaco_vaga.status = "1"
          if @espaco_vaga.update_attributes(params[:espaco_vaga])
          puts "salvou"
          end
          @vaga_associada.save
        end
      end
    end
  end

  def create
    @historico_de_contato = HistoricoDeContato.new(params[:historico_de_contato])

    respond_to do |format|
      if @historico_de_contato.save
        format.html { redirect_to "/", notice: 'Negociacao salva.' }
      format.js
      else
        format.html { redirect_to :back }
     	format.js
      end
    end

    @espaco_gravado = Espaco.find_by_id(@historico_de_contato.espaco_id)
    @espaco_gravado.status = @historico_de_contato.status
    if @espaco_gravado.update_attributes(params[:espaco_gravado])
    end

    if session[:vagas]
    	@vagas = session[:vagas]
    else
    	@vagas = Array.new
    end
    @vagas.each do |vaga|
      @vaga_associada = VagaAssociada.new(:espaco_id => vaga, :id_unidade_negociada => @historico_de_contato.espaco_id)
      @espaco_vaga = Espaco.find(vaga)
      @espaco_vaga.status = "1"
      if @espaco_vaga.update_attributes(params[:espaco_vaga])
      puts "salvou"
      end
      @vaga_associada.save
    end
  end

  def alterar_status
  	@historico_de_contato = HistoricoDeContato.find_by_id(params[:id])
  	@historico_de_contato.status = params[:status]
    @historico_de_contato.avaliacao = params[:avaliacao]
  	@historico_de_contato.save
  	@espaco_gravado = Espaco.find_by_id(@historico_de_contato.espaco_id)
  	@espaco_gravado.status = @historico_de_contato.status
  	@espaco_gravado.save

  	redirect_to ('/')

  end

  def export_selected
      filename = "pedido.xls" 
      exporter = PedidoExcelExporter.new('Pedido')
      pedido_to_export = HistoricoDeContato.find_by_id(params[:id])
      image = pedido_to_export.empresa.empresa_logomarca.thumb('100x100')
      content = exporter.export_one(pedido_to_export)
      send_data content.string.bytes.to_a.pack("C*"), type: :xls, disposition: 'attachment', filename: filename
  end


end
