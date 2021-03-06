require "rails_helper"

feature "registered user can add games" do
  scenario "signed in users can go to a form to add a game" do
    bob = FactoryGirl.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: bob.email
    fill_in 'Username', with: bob.username
    fill_in 'Password', with: bob.password
    click_button 'Log in'

    click_link 'Add Game'

    expect(page).to have_content('New Game Form')
  end
  scenario "users not signed in don't see add game link" do
    visit "/"
    expect(page).to_not have_content('Add Game')
  end
  scenario "users not signed in can't go to the add a game form" do
    visit new_game_path
    expect(page).to have_content('Game List:')
    expect(page).to_not have_content('New Game Form')
  end
  scenario "signed in users can successfully add a game" do
    bob = FactoryGirl.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: bob.email
    fill_in 'Username', with: bob.username
    fill_in 'Password', with: bob.password
    click_button 'Log in'

    visit new_game_path

    fill_in 'Title', with: 'Title of a Game'
    fill_in 'Description', with: 'Some kind of description'
    select 'NES', from: 'Platform'
    fill_in 'Release Year', with: '1990'
    click_button 'Add this Game'

    expect(page).to have_content('Game successfully saved!')
    expect(page).to have_content('Title of a Game')
    expect(page).to have_content('Some kind of description')
    expect(page).to have_content('NES')
    expect(page).to have_content('1990')
  end
  scenario "signed in users can successfully add a game without release year" do
    bob = FactoryGirl.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: bob.email
    fill_in 'Username', with: bob.username
    fill_in 'Password', with: bob.password
    click_button 'Log in'

    visit new_game_path

    fill_in 'Title', with: 'Title of a Game'
    fill_in 'Description', with: 'Some kind of description'
    select 'NES', from: 'Platform'

    click_button 'Add this Game'

    expect(page).to have_content('Game successfully saved!')
  end
  scenario "signed in users don't add game if information is invalid" do
    bob = FactoryGirl.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: bob.email
    fill_in 'Username', with: bob.username
    fill_in 'Password', with: bob.password
    click_button 'Log in'

    visit new_game_path
    fill_in 'Release Year', with: '90'

    click_button 'Add this Game'
    expect(page).to have_content("Title can't be blank")
    expect(page).to have_content("Description can't be blank")
    expect(page).to have_content("Platform can't be blank")
    expect(page).to have_content("Release year is the wrong length")
    expect(page).to have_content("(should be 4 characters)")
  end
  scenario "signed in users don't add game if information is invalid" do
    bob = FactoryGirl.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: bob.email
    fill_in 'Username', with: bob.username
    fill_in 'Password', with: bob.password
    click_button 'Log in'

    visit new_game_path
    fill_in 'Release Year', with: 'five'

    click_button 'Add this Game'
    expect(page).to have_content("Release year is not a number")
  end
  scenario "new game appears on list on main page" do
    bob = FactoryGirl.create(:user)
    visit new_user_session_path
    fill_in 'Email', with: bob.email
    fill_in 'Username', with: bob.username
    fill_in 'Password', with: bob.password
    click_button 'Log in'

    visit new_game_path

    fill_in 'Title', with: 'Title of a Game'
    fill_in 'Description', with: 'Some kind of description'
    select 'NES', from: 'Platform'
    fill_in 'Release Year', with: '1990'
    click_button 'Add this Game'

    visit root_path
    expect(page).to have_content("Title of a Game")
  end
end
