class ApplicationController
  module SysprepAnswerFile
    def upload_sysprep_file
      @_params.delete :commit
      @upload_sysprep_file = true
      @edit = session[:edit]
      build_grid
      if params.fetch_path(:upload, :file).respond_to?(:read)
        @edit[:new][:sysprep_upload_file] = params[:upload][:file].original_filename
        begin
          @edit[:new][:sysprep_upload_text] = SysprepFile.new(params[:upload][:file]).content
          msg = _('Sysprep "%{params}" upload was successful') % {:params => params[:upload][:file].original_filename}
          add_flash(msg)
        rescue StandardError => bang
          @edit[:new][:sysprep_upload_text] = nil
          msg = _("Error during Sysprep \"%{params}\" file upload: %{message}") %
                  {:params => params[:upload][:file].original_filename, :message => bang.message}
          add_flash(msg, :error)
        end
      else
        @edit[:new][:sysprep_upload_text] = nil
        msg = _("Use the Choose file button to locate an Upload file")
        add_flash(msg, :error)
      end
    end
  end
end
