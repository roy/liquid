# Liquid template engine

## Introduction

Liquid is a template engine which I wrote for very specific requirements

* It has to have beautiful and simple markup. Template engines which don't produce good looking markup are no fun to use.
* It needs to be non evaling and secure. Liquid templates are made so that users can edit them. You don't want to run code on your server which your users wrote.
* It has to be stateless. Compile and render steps have to be seperate so that the expensive parsing and compiling can be done once and later on you can just render it passing in a hash with local variables and objects.

## Why should I use Liquid

* You want to allow your users to edit the appearance of your application but don't want them to run **insecure code on your server**.
* You want to render templates directly from the database
* You like smarty (PHP) style template engines
* You need a template engine which does HTML just as well as emails
* You don't like the markup of your current templating engine

## What does it look like?

<code>
  <ul id="products">
    {% for product in products %}
      <li>
        <h2>{{product.name}}</h2>
        Only {{product.price | price }}

        {{product.description | prettyprint | paragraph }}
      </li>
    {% endfor %}
  </ul>
</code>

## Rails 3

This fork of Liquid exists to make it work with Rails 3. Unfortunately, it doesn't work smoothly with layouts and requires a workaround. The way I have made it render the content with a layout is to use render\_to\_string to render the action's view with layout set to nil, then manually add that to view\_assigns. This looks like:

    def index # or any other controller action
      @content_for_layout = render_to_string(:action => :index, :layout => nil)
    end

    private

    def view_assigns # this overrides the locals that are handed to the view
      { :content_for_layout => @content_for_layout }
    end

This is an advanced hack and not for the feint of heart. Please exercise caution if trying to implement this without an understanding of how view assigns and rendering work. I'm offering this code so that someone else doesn't have to go through what I went through trying to get Liquid working smoothly in Rails 3. Do not expect a high level of support.

If you accept the above warning, to integrate it into your Rails 3 app you can either `require 'liquid/railtie'` in your `config/application.rb` or add to your Gemfile:

    gem 'liquid', :git => 'https://github.com/joefiorini/liquid.git', :require => 'liquid/railtie'

## Howto use Liquid

Liquid supports a very simple API based around the Liquid::Template class.
For standard use you can just pass it the content of a file and call render with a parameters hash.

<pre>
@template = Liquid::Template.parse("hi {{name}}") # Parses and compiles the template
@template.render( 'name' => 'tobi' )              # => "hi tobi"
</pre>

