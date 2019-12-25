class ProductChannel < ApplicationCable::Channel
    def subscribed
        if params[:room] == 'public'
            stream_from global_channel
        else
            stream_from stream_channel
        end
    end
  
    def create data
        @product = Product.new(data["form"])
        if @product.save
            broadcast 'create', 'created'
            broadcast_by 'create', @product.id
        else
            broadcast 'create', 'error'
        end
    end

    def update data
        @product = find_product data["id"]
        if @product.update(data["form"]) 
            broadcast 'update','ok'
            broadcast_by 'update', @product.id
        else
            broadcast 'update', 'error'
        end
    end

    def delete data
        @product = find_product data["id"]
        @product.delete
        broadcast_by 'delete', @product.id
        broadcast 'delete', "deleted"
    end

    def index
        broadcast 'index', Product.all
    end

    def show data
        @product = find_product data["id"]
        broadcast 'show', @product
    end

    private

    def find_product id
        Product.find(id)
    end

    def stream_channel
        "product_#{params[:room]}"
    end

    def global_channel
        "products_public"
    end

    def broadcast method, data
        ActionCable.server.broadcast(stream_channel, {action: method, data: data})
    end

    def broadcast_by method, id
        ActionCable.server.broadcast(global_channel, {action: method, data: id})
    end
end