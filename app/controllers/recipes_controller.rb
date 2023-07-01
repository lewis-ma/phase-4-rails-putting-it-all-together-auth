class RecipesController < ApplicationController
  def index
    if logged_in?
      recipes = Recipe.includes(:user).all
      render json: recipes, include: :user
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  def create
    if logged_in?
      recipe = current_user.recipes.build(recipe_params)
      if recipe.save
        render json: recipe, include: :user, status: :created
      else
        render json: { errors: recipe.errors.full_messages }, status: :unprocessable_entity
      end
    else
      render json: { error: 'Unauthorized' }, status: :unauthorized
    end
  end

  private

  def recipe_params
    params.require(:recipe).permit(:title, :instructions, :minutes_to_complete)
  end
end
