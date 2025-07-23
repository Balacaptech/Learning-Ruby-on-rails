module Api
  class BooksController < ApplicationController
    include Rails.application.routes.url_helpers
    before_action :set_user
    before_action :set_book, only: [:show, :update, :destroy]

    def index
      books = @user.books.where(deleted: false)

      if params[:search].present?
        q = "%#{params[:search]}%"
        books = books.where(
          "title ILIKE :q OR author ILIKE :q OR description ILIKE :q OR CAST(price AS TEXT) ILIKE :q",
          q: q
        )
      else
        books = books.where("title ILIKE ?", "%#{params[:title]}%") if params[:title].present?
        books = books.where("author ILIKE ?", "%#{params[:author]}%") if params[:author].present?
        books = books.where("description ILIKE ?", "%#{params[:description]}%") if params[:description].present?
        books = books.where(price: params[:price]) if params[:price].present?
      end

      if books.exists?
        render json: {
          status: 'success',
          books: books.map { |book| book_json(book) }
        }, status: :ok
      else
        render json: { status: 'error', message: 'No books found with given criteria' }, status: :not_found
      end
    end

    def create
        book = @user.books.build(book_params.except(:file))

        if params[:file].present?
          begin
            file = params[:file]
            filename = file.original_filename
            content_type = file.content_type
            key = "images/book/#{SecureRandom.uuid}/#{filename}"


            blob = ActiveStorage::Blob.create_and_upload!(
              io: file,
              filename: filename,
              content_type: content_type,
              key: key
            )

            book.file.attach(blob)

            # ✅ Construct and assign S3 URL BEFORE saving
            s3_url = "https://#{ENV['AWS_BUCKET_NAME'] || 'balamurugan17062025'}.s3.amazonaws.com/#{blob.key}"
            book.file_url = s3_url

          rescue => e
            Rails.logger.error "File upload failed: #{e.message}"
            render json: { status: 'error', message: 'File upload failed' }, status: :unprocessable_entity
            return
          end
        end

        if book.save
          render json: {
            status: 'success',
            message: 'Book created successfully',
            book: book_json(book)
          }, status: :created
        else
          render json: {
            status: 'error',
            message: 'Failed to create book',
            errors: book.errors.full_messages
          }, status: :unprocessable_entity
        end
      end

    def show
      render json: book_json(@book)
    end

    def update
          if @book.update(book_params.except(:file))
            if params[:file].present?
              begin
                file = params[:file]
                filename = file.original_filename
                content_type = file.content_type
               key = "images/book/#{SecureRandom.uuid}/#{filename}"


                blob = ActiveStorage::Blob.create_and_upload!(
                  io: file,
                  filename: filename,
                  content_type: content_type,
                  key: key
                )

                @book.file.attach(blob)

                # ✅ Construct S3 URL and save to file_url
                s3_url = "https://#{ENV['AWS_BUCKET_NAME'] || 'balamurugan17062025'}.s3.amazonaws.com/#{blob.key}"
                @book.update_column(:file_url, s3_url)

              rescue => e
                Rails.logger.error "File upload failed: #{e.message}"
                render json: { status: 'error', message: 'File upload failed' }, status: :unprocessable_entity
                return
              end
            end

            render json: {
              status: 'success',
              updated: true,
              book: book_json(@book)
            }, status: :ok
          else
            render json: {
              status: 'error',
              errors: @book.errors.full_messages
            }, status: :unprocessable_entity
          end
        end


    def destroy
      if @book.update(deleted: true)
        render json: { status: 'success', message: 'Book deleted successfully' }, status: :ok
      else
        render json: { status: 'error', message: 'Failed to delete book' }, status: :unprocessable_entity
      end
    end

    private

    def book_params
      params.permit(:title, :author, :description, :price, :file)
    end

    # test

    def set_user
      @user = User.find_by(id: params[:user_id])
      unless @user
        render json: { error: "User not found" }, status: :not_found
      end
    end

    def set_book
      @book = @user.books.find_by(id: params[:id])
      unless @book
        render json: { error: 'Book not found or unauthorized' }, status: :not_found
      end
    end

    def book_json(book)
      {
        id: book.id,
        title: book.title,
        author: book.author,
        description: book.description,
        price: book.price,
        file_url: book.file_url
      }
    end
  end
end
