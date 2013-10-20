class VagaAssociadasController < ApplicationController
  # GET /vaga_associadas
  # GET /vaga_associadas.json
  def index
    @vaga_associadas = VagaAssociada.all

    respond_to do |format|
      format.html # index.html.erb
      format.json { render json: @vaga_associadas }
    end
  end

  # GET /vaga_associadas/1
  # GET /vaga_associadas/1.json
  def show
    @vaga_associada = VagaAssociada.find(params[:id])

    respond_to do |format|
      format.html # show.html.erb
      format.json { render json: @vaga_associada }
    end
  end

  # GET /vaga_associadas/new
  # GET /vaga_associadas/new.json
  def new
    @vaga_associada = VagaAssociada.new

    respond_to do |format|
      format.html # new.html.erb
      format.json { render json: @vaga_associada }
    end
  end

  # GET /vaga_associadas/1/edit
  def edit
    @vaga_associada = VagaAssociada.find(params[:id])
  end
  
  def prepare_to_create
	
	
  end
  # POST /vaga_associadas
  # POST /vaga_associadas.json
  def create
    @vaga_associada = VagaAssociada.new(:espaco_id => params[:espaco_id], :id_unidade_negociada => params[:id_unidade_negociada])
    @espaco_vaga = Espaco.find(params[:espaco_id])
    @espaco_vaga.status = "1"
    if @espaco_vaga.update_attributes(params[:espaco_vaga])
      puts "salvou"
    end

    respond_to do |format|
      if @vaga_associada.save
        format.html { redirect_to :back, notice: 'Vaga associada was successfully created.' }
        format.json { render json: @vaga_associada, status: :created, location: @vaga_associada }
      else
        format.html { render action: "new" }
        format.json { render json: @vaga_associada.errors, status: :unprocessable_entity }
      end
    end
  end

  # PUT /vaga_associadas/1
  # PUT /vaga_associadas/1.json
  def update
    @vaga_associada = VagaAssociada.find(params[:id])

    respond_to do |format|
      if @vaga_associada.update_attributes(params[:vaga_associada])
        format.html { redirect_to @vaga_associada, notice: 'Vaga associada was successfully updated.' }
        format.json { head :ok }
      else
        format.html { render action: "edit" }
        format.json { render json: @vaga_associada.errors, status: :unprocessable_entity }
      end
    end
  end

  # DELETE /vaga_associadas/1
  # DELETE /vaga_associadas/1.json
  def destroy
    @vaga_associada = VagaAssociada.find(params[:id])
    @espaco_vaga = Espaco.find(@vaga_associada.espaco_id)
    @espaco_vaga.status = "0"
    if @espaco_vaga.update_attributes(params[:espaco_vaga])
      puts "salvou"
    end
    @vaga_associada.destroy

    respond_to do |format|
      format.html { redirect_to (:back) }
      format.json { head :ok }
    end
  end
end
