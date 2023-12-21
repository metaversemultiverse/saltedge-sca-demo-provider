class ProviderActionsController < BaseController
  get '/actions' do
    @provider_actions = Action.all.order(id: :desc)

    erb :actions
  end

  get '/actions/create/:type' do
    action_type = params[:type]
    connections = Connection.all.select(&:authorized?)

    redirect '/actions' if connections.empty?

    action = Action.create!(
      code: SecureRandom.uuid,
      status: Action::PENDING,
      multiple: action_type == 'multiple',
      description_type: action_type == 'multiple' ? 'text' : action_type
    )

    CreateActionWorker.perform_async(
      action_id: action.id
    )

    redirect '/actions'
  end

  get '/actions/:action_id/update' do
    action = Action.find_by(id: params['action_id'])

    redirect '/actions' unless action

    UpdateActionWorker.perform_async(
      action_id: action.id
    )

    redirect '/actions'
  end

  get '/actions/:action_id/close' do
    action = Action.find_by(id: params['action_id'])

    redirect '/actions' unless action

    action.update!(status: Action::CLOSED)

    CloseActionWorker.perform_async(
      action_id: action.id
    )

    redirect '/actions'
  end

  get '/actions/:action_id/authorizations' do
    @action = Action.find_by(id: params['action_id'])

    redirect '/actions' unless @action

    @authorizations = @action.parsed_authorizations.each(&:symbolize_keys!)

    erb :authorizations
  end
end
