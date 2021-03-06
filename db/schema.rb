# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20120704000804) do

  create_table "clientes", :force => true do |t|
    t.string   "empresa_id"
    t.string   "usuario_id"
    t.string   "tipo"
    t.string   "nome"
    t.string   "cpf_cnpj"
    t.string   "endereco"
    t.string   "ddd"
    t.string   "telefone"
    t.string   "nome_contato"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "detalhe_da_unidades", :force => true do |t|
    t.string   "espaco_id"
    t.integer  "vagas_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "empreendimentos", :force => true do |t|
    t.string   "empresa_id"
    t.string   "codigo"
    t.string   "nome_do_empreendimento"
    t.float    "cub"
    t.integer  "dias_val_neg"
    t.boolean  "ativo"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "empresas", :force => true do |t|
    t.string   "nome"
    t.string   "logomarca"
    t.string   "empresa_logomarca_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "espacos", :force => true do |t|
    t.string   "empreendimento_id"
    t.string   "pavimento_id"
    t.string   "tipo_de_espaco"
    t.string   "identificacao"
    t.float    "area_garagem"
    t.integer  "numero_garagem"
    t.float    "area_comum"
    t.float    "area_privativa"
    t.float    "area_total"
    t.float    "valor_m2"
    t.float    "valor_total"
    t.string   "pega_sol"
    t.string   "vaga_dupla"
    t.string   "localizacao"
    t.string   "planta_uid"
    t.integer  "status"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "historico_de_contatos", :force => true do |t|
    t.date     "data"
    t.string   "cliente_id"
    t.string   "espaco_id"
    t.string   "usuario_id"
    t.string   "empresa_id"
    t.string   "empreendimento_id"
    t.string   "negociacao"
    t.string   "status"
    t.string   "avaliacao"
    t.integer  "simulacao_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "pavimentos", :force => true do |t|
    t.string   "empreendimento_id"
    t.string   "andar"
    t.string   "planta_pavimento"
    t.string   "pavimento_imagem_uid"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  add_index "sessions", ["session_id"], :name => "index_sessions_on_session_id"
  add_index "sessions", ["updated_at"], :name => "index_sessions_on_updated_at"

  create_table "simulacaos", :force => true do |t|
    t.float    "valor_total"
    t.float    "entrada"
    t.float    "valor_entrada"
    t.float    "saldo"
    t.float    "cub"
    t.float    "parcelas_30"
    t.float    "parcelas_36"
    t.float    "parcelas_48"
    t.float    "parcelas_48_juros"
    t.float    "parcelas_60"
    t.float    "parcelas_60_juros"
    t.string   "historico_de_contato_id"
    t.datetime "created_at"
    t.datetime "updated_at"
    t.float    "parcelas_12"
    t.float    "parcelas_24"
    t.float    "parcelas_50"
  end

  create_table "usuarios", :force => true do |t|
    t.string   "empresa_id"
    t.string   "nome"
    t.string   "username"
    t.string   "crypted_password"
    t.string   "password_field"
    t.string   "tipo"
    t.integer  "permissao_id"
    t.string   "persistence_token"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

  create_table "vaga_associadas", :force => true do |t|
    t.string   "identificacao"
    t.string   "espaco_id"
    t.string   "id_unidade_negociada"
    t.string   "historico_de_contato_id"
    t.datetime "created_at"
    t.datetime "updated_at"
  end

end
