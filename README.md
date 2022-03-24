# ViewContext

Rails view helper [render](https://guides.rubyonrails.org/layouts_and_rendering.html#using-partials-to-simplify-views) method is not easy to render complicated　layout html partial.

ViewContext is a tiny helper class to enhance Rails partial template capability with a simple way.

[view_component](https://github.com/github/view_component) maybe not a necessary dependency if you just want to keep simple.

No gem, just add [view_context.rb](https://github.com/qichunren/view_context/blob/main/view_context.rb)  to your Rails project autload path.

## Demo usage

Render a tailwindcss tab html snippet for example.

```html
# _tab.html.erb
<div class="px-4 flex items-center justify-between border-b-2 border-gray-400">
  <ul class="flex px-4">
    <!-- slot for tab links -->
    <%= yield %>
  </ul>
  <!-- slot for right button -->
  <%= side %>
</div>
```

And use the partial in a page in general,:

```html
<%= render "shared/tab", side: "<a href='/some' class='btn'></a>".html_safe do  %>
  <li><a href="/some">Tab 1</a></li>
  <li><a href="/some">Tab 2</a></li>
  <li><a href="/some">Tab 3</a></li>
<% end %>
```

Now with [ViewContext](https://github.com/qichunren/view_context/blob/main/view_context.rb) helper class, things became simple and flexible.

First, change a little in _tab.html.erb partial:

```
<% _view_context = ViewContext.new(self) %>
<div class="px-4 flex items-center justify-between border-b-2 border-gray-400">
	<ul class="tab px-4">
		<%= yield _view_context  %>
		<%= _view_context.main %>
	</ul>
	<%= _view_context.side %>
</div>
```

Then, render tab template partial below:

```html
<%= render "shared/tab" do |context| %>

  <% context.set_main do %>
    <% PostCategory.all.each do |post_category| %>
      <li class="<%= 'active' if params[:category].to_i == post_category.id %>">
        <%= link_to post_category.name, admin_posts_path(category: post_category.id) %>
      </li>
    <% end %>
  <% end %>

  <% context.set_side do %>
    <%= link_to admin_post_categories_path do %>
      <%= heroicon "cog", options: { class: "w-4 h-4 text-primary-500 mr-2" } %>
    <% end %>
  <% end %>

<% end %>
```
