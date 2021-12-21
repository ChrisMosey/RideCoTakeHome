class ApplicationController < ActionController::Base
    
    # Exception Handling
    class BadRequestError < StandardError
    end
    class NotFoundError < StandardError
    end

    def get_lists()
        lists = List.all()

        render json: lists, status: 200;
    end

    def new_list()
        list_name = params[:list_name]

        raise BadRequestError if list_name.blank?

        List.create(name: list_name);

        lists = List.all()

        render json: lists, status: 200
    rescue BadRequestError
        render json: {}, status: 400
    end

    def edit_list()
        list_id = params[:list_id]
        list_name = params[:list_name]

        raise BadRequestError if list_name.blank?

        list = List.find_by(id: list_id)

        raise NotFoundError if list.blank?

        list.update(name: list_name);

        render json: list, status: 200

    rescue BadRequestError
        render json: {}, status: 400
    rescue NotFoundError
        render json: {}, status: 404
    end

    def delete_list()
        list_id = params[:list_id]

        list = List.find_by(id: list_id)

        raise NotFoundError if list.blank?

        list.destroy

        lists = List.all

        render json: lists, status: 200

    rescue NotFoundError
        render json: {}, status: 404
    end

    def get_list()
        list_id = params[:list_id]

        list = List.includes(:list_items).find_by(id: list_id)

        raise NotFoundError if list.blank?

        render json: { name: list.name, items: list.list_items }, status: 200
        
    rescue NotFoundError
        render json: {}, status: 404
    end

    def add_list_item()
        list_id = params[:list_id]
        label = params[:label]

        list = List.find_by(id: list_id)

        raise NotFoundError if list.blank?

        ListItem.create(label: label, list_id: list.id)

        render json: { name: list.name, items: list.list_items }, status: 200
    rescue NotFoundError
        render json: {}, status: 404
    end

    def edit_list_item()
        list_id = params[:list_id]
        list_item_id = params[:list_item_id]
        label = params[:label]
        checked = params[:checked]

        list_item = ListItem.find_by(id: list_item_id, list_id: list_id)
        
        raise NotFoundError if list_item.blank?

        list_item.label = label unless label.blank?

        list_item.checked = checked unless checked.blank?

        list_item.save

        render json: list_item, status: 200

    rescue NotFoundError
        render json: {}, status: 404
    end

    def delete_list_item()
        list_id = params[:list_id]
        list_item_id = params[:list_item_id]

        list_item = ListItem.find_by(id: list_item_id, list_id: list_id)
        
        raise NotFoundError if list_item.blank?

        list_item.destroy

        list = List.includes(:list_items).find_by(id: list_id)

        render json: { name: list.name, items: list.list_items }, status: 200

    rescue NotFoundError
        render json: {}, status: 404
    end
end
