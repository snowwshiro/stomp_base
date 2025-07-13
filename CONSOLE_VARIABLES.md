# Console Variable Assignment Enhancement

This document describes the enhanced console functionality that supports variable assignment and persistence.

## Overview

The StompBase console has been enhanced to support variable assignment and multi-line operations, allowing users to:

- Store intermediate results in variables for later use
- Build complex operations step by step
- Maintain state between commands within the same session
- Perform multi-line operations

## Features

### Variable Assignment

Variables can be assigned using standard Ruby syntax:

```ruby
# Assign a number
x = 42

# Assign a string
name = "John Doe"

# Assign an array
numbers = [1, 2, 3, 4, 5]

# Assign complex expressions
result = numbers.sum * 2
```

### Variable Persistence

Variables persist throughout the console session:

```ruby
# First command
user = User.find(123)

# Second command (uses the variable from first command)
user.name  # => "John Doe"

# Third command (combines variables)
orders = user.orders.recent
total = orders.sum(:amount)
```

### Variable Listing

Use the `vars` command to list all stored variables:

```ruby
> vars
Variables:
  user: #<User id: 123, name: "John Doe", ...>
  orders: [#<Order id: 1, ...>, #<Order id: 2, ...>]
  total: 1250.0
```

### Multi-line Input

The console supports multi-line input using Shift+Enter:

```ruby
# Press Shift+Enter to continue on new line
def calculate_stats(orders)
  total = orders.sum(:amount)
  avg = total / orders.count
  { total: total, average: avg }
end

# Then execute the function
stats = calculate_stats(orders)
```

## Usage Examples

### Basic Variable Assignment

```ruby
# Assign and use variables
> x = 42
=> 42

> y = 8
=> 8

> result = x + y
=> 50

> result
=> 50
```

### Working with ActiveRecord Models

```ruby
# Find a user and store in variable
> user = User.first
=> #<User id: 1, name: "John", email: "john@example.com">

# Use the variable in subsequent commands
> user.email
=> "john@example.com"

# Find related records
> posts = user.posts
=> [#<Post id: 1, title: "Hello World">, ...]

# Perform calculations
> post_count = posts.count
=> 5
```

### Building Complex Queries

```ruby
# Build query step by step
> base_query = Post.published
> filtered_query = base_query.where('created_at > ?', 1.week.ago)
> ordered_query = filtered_query.order(:created_at)
> final_results = ordered_query.limit(10)

# Execute the query
> final_results.to_a
=> [#<Post id: 15, title: "Recent Post">, ...]
```

### Data Analysis

```ruby
# Analyze order data
> orders = Order.last(100)
> total_amount = orders.sum(:amount)
> average_amount = total_amount / orders.count
> max_order = orders.max_by(&:amount)

# View results
> vars
Variables:
  orders: [#<Order id: 1, amount: 50.0>, ...]
  total_amount: 5000.0
  average_amount: 50.0
  max_order: #<Order id: 42, amount: 250.0>
```

## Technical Implementation

### Session-based Storage

Variables are stored in the user's session using persistent Ruby bindings:

- Each console session maintains its own variable scope
- Variables are isolated between different users/sessions
- Variables persist throughout the session but are cleared when the session ends

### Security Considerations

The console maintains all existing security features:

- Production environment protection (disabled by default)
- Dangerous command detection and blocking
- Timeout protection (10 second limit per command)
- Session isolation between users

### Memory Management

- Variables are stored in session memory
- Memory usage is automatically cleaned up when sessions end
- No persistent storage - variables don't survive server restarts

## Backward Compatibility

The enhanced console is fully backward compatible:

- All existing single-command usage continues to work
- No breaking changes to existing functionality
- All existing safety features remain active

## UI Enhancements

The console interface includes:

- Updated placeholder text showing variable assignment examples
- Quick access "vars" button to list variables
- Enhanced example commands demonstrating variable usage
- Multi-line input support with Shift+Enter

## API Response Format

The console API continues to return JSON responses with the same format:

```json
{
  "success": true,
  "result": "42",
  "error": false
}
```

For the `vars` command:

```json
{
  "success": true,
  "result": "Variables:\n  x: 42\n  name: \"John\"",
  "error": false
}
```

## Future Enhancements

Potential future improvements could include:

- Variable import/export functionality
- Variable type inspection
- Variable history tracking
- Integration with Rails console helpers
- Advanced debugging features

## Troubleshooting

### Common Issues

1. **Variables not persisting**: Ensure you're using the same session/browser tab
2. **NameError for undefined variables**: Check variable names with the `vars` command
3. **Session timeout**: Variables are cleared when the session expires

### Best Practices

1. Use descriptive variable names
2. Use the `vars` command to verify variable state
3. Break complex operations into smaller steps
4. Be mindful of memory usage with large datasets
5. Test dangerous operations in development first

## Examples in Different Languages

### English Console Examples

```ruby
# User management
current_user = User.find(1)
user_posts = current_user.posts.published
recent_posts = user_posts.where('created_at > ?', 1.week.ago)

# Data analysis
revenue = Order.sum(:total)
user_count = User.count
avg_order_value = revenue / Order.count

# Complex calculations
monthly_stats = Order.group_by_month(:created_at).sum(:total)
```

### Japanese Console Examples (日本語)

```ruby
# ユーザー管理
現在のユーザー = User.find(1)
ユーザー投稿 = 現在のユーザー.posts.published
最近の投稿 = ユーザー投稿.where('created_at > ?', 1.week.ago)

# データ分析
収益 = Order.sum(:total)
ユーザー数 = User.count
平均注文価格 = 収益 / Order.count
```

Note: While variable names can use Unicode characters in Ruby, it's recommended to use ASCII names for better compatibility.