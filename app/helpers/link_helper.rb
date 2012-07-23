module LinkHelper
  


  
  def context_index(context)
    # note: we want this to blow up if (NOT lineage.last.is_a? Symbol)
    index_symbol = context.last.class.name.pluralize.underscore.to_sym
    a = context.compact[0..-2] << index_symbol
    is_all_symbols = a.map {|item| item.is_a?(Symbol)}.all?
    a = is_all_symbols ? a.join('_') : a
    a
  end  
  
  def index_link_title(index_offset, context)
    if index_offset == -1
      "View " + context.last.class.name.underscore.pluralize.humanize
    else
      "View " + context[0..index_offset].last.class.name.underscore.humanize
    end
  end
  
  def delete_link_text(context, new_opts = {}, path_opts = {})  
    opts = {:title => 'Delete', :method => :delete,
           :confirm  => 'Are you sure?  Clicking OK will delete this record permanently',
           :alt_text => 'Delete',
           :class => 'btn btn-danger pull-right'}.merge(new_opts)        
    link_to polymorphic_path(context, path_opts), opts do
      haml_concat opts[:title]
      haml_tag :i, :class => opts[:icon_class] ||'icon-remove icon-white'
    end
  end  
  
  def view_link_text(context, new_opts = {}, path_opts = {})
    opts = {:title => 'View', :class => 'btn btn-success'}.merge(new_opts)        
    link_to(opts[:title], polymorphic_path(context, path_opts), opts)
  end
  
  
  def edit_link_text(context, new_opts = {}, path_opts = {})
    opts = {:title => 'Edit', :class => 'btn btn-primary'}.merge(new_opts)
    link_to edit_polymorphic_path(context, path_opts), opts do
      haml_concat opts[:title]
      haml_tag :i, :class => 'icon-edit icon-white'
    end      
  end  

  
  def action_links(context, opts = {})
    context = lineage unless context
    index_offset = -((opts[:index_offset] || 0) +1)
    options = {:index => {:title => index_link_title(index_offset, context)}.merge(opts[:index] || {}), :exclude => []}.merge((opts || {}))    
    index_path = index_offset == -1 ? context_index(context) : context[0..index_offset] unless options[:exclude].include?(:index)
    a = []
    a << [link_to(options[:index][:title], opts[:index_path] || polymorphic_path(index_path))] unless options[:exclude].include?(:index)
    a << [ view_link_text(options[:show].try([], :path) || context, options.merge(options[:show] || {}))] unless options[:exclude].include?(:show)
    a << [ edit_link_text(context, options.merge(options[:edit] || {}))] unless options[:exclude].include?(:edit)
    a << [ delete_link_text(context, options.merge(options[:delete] || {}))] unless options[:exclude].include?(:delete) 
    capture_haml do
      haml_tag :div, :class => "btn-group" do
        haml_concat a.flatten.compact.join('')
      end
    end
  end
  
  def exclude_actions(exclude=nil)
    if ['edit', 'show'].include?(params[:action])
      ([params[:action].to_sym] + (exclude || [])).uniq
    else
      exclude || []
    end
  end

end
