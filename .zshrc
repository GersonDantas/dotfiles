if [[ -r "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh" ]]; then
  source "${XDG_CACHE_HOME:-$HOME/.cache}/p10k-instant-prompt-${(%):-%n}.zsh"
fi

export ZSH="$HOME/.oh-my-zsh"

ZSH_THEME="powerlevel10k/powerlevel10k"
POWERlEVEL10K_MODE="nerdfont-complete"

plugins=(
  git
  zsh-syntax-highlighting
  fzf
  zsh-autosuggestions
)

source $ZSH/oh-my-zsh.sh

[[ ! -f ~/.p10k.zsh ]] || source ~/.p10k.zsh

export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh" 
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion" 


source /opt/homebrew/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source $HOME/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

# Makes the Commits with Google AI

ccm() {
  local custom_message="$1"

  local base_message="Write a concise commit message for this diff. Write only the commit suggestion without any extra information."

  local default_message='Analyze the git diff carefully and determine the correct project context. Include the keyword, the project name, the resource, the "-", and then the message. In this exact sequence: [keyword] project: feature name - message. Begin each commit message with one of the following keywords: [add] for new features or additions, [remove] for deletions or removals, [update] for modifications or updates, [clean] for code refactoring or organization without logic changes, and [fix] for bug fixes or corrections. IMPORTANT: Look at the file paths in the diff to determine the correct project context - if files start with "frontend/" use "frontend", if files start with "backend/" use "backend", if both are present use "multi env". Examples include: [add] frontend: tinymce - editor helper function to remove text between ranges, [fix] frontend: masks - after adding a new mask, three of all masks not updating, and [clean] backend: refactor user service - split function into smaller utilities. For code refactoring or organization, use [clean] for commits that involve code reorganization or refactoring without changing the logic. Examples include moving files to a new folder, renaming variables, or splitting a function into smaller functions. Add the keyword (partial) if the commit represents incomplete work, such as saving unfinished work at the end of the day. For example: [add] (partial) frontend: TinyMCE - editor helper function to remove text between ranges. If a commit changes files in more than one project (e.g., frontend, backend), replace the project name with "multi env". For example: [add] multi env: ai assistant - added report generation task in AI assistant.'

  local message="${base_message}${custom_message:+ - $custom_message}${custom_message:-"$default_message"}"

  # Get the current branch name and extract the feature
  local branch_name
  branch_name=$(git rev-parse --abbrev-ref HEAD)
  local feature_name
  # Extract everything after the first "/", replace remaining "/" with spaces, and remove "-"
  feature_name=$(echo "$branch_name" | sed -E 's:^[^/]*/::' | sed 's:/: :g' | sed 's/-/ /g')

  # Generate the commit message
  local commit_message
  commit_message=$(git diff --staged | gai "$message")

  # Check if the commit message was generated successfully
  if [[ -z "$commit_message" ]]; then
    echo "Error: No commit message generated."
    return 1
  fi

  # Replace the feature in the commit message with the extracted feature_name
  local updated_commit_message
  updated_commit_message=$(echo "$commit_message" | sed -E "s/(: )[a-zA-Z0-9_ -]+( -)/\1$feature_name\2/")

  # Show the updated commit message to the user
  echo "$updated_commit_message"
  echo

  # Ask for confirmation
  echo "Is this commit message okay? (y/n): "
  read confirmation

  if [[ "$confirmation" == "y" || "$confirmation" == "Y" ]]; then
    # Confirmed, make the commit
    git commit -m "$updated_commit_message"
    echo "Commit made successfully."
    
    # Clear chat history after successful commit
    if [[ -d "$HOME/chats" ]]; then
      rm -rf "$HOME/chats"/*
      echo "Chat history cleared."
    fi
  else
    # Ask if the user wants to edit or abort
    echo "Do you want to edit the message? (y/n):"
    read action
    if [[ "$action" == "y" || "$action" == "Y" || "$action" == "yes" || "$action" == "Yes" ]]; then
      # Open the message in the default editor for editing
      echo "$updated_commit_message" > /tmp/commit_message.txt
      ${EDITOR:-nano} /tmp/commit_message.txt
      new_commit_message=$(cat /tmp/commit_message.txt)
      if [[ -z "$new_commit_message" ]]; then
        echo "Error: No commit message provided. Aborting."
        return 1
      fi
      git commit -m "$new_commit_message"
      echo "Commit made successfully with edited message."
      rm /tmp/commit_message.txt
      
      # Clear chat history after successful commit
      if [[ -d "$HOME/chats" ]]; then
        rm -rf "$HOME/chats"/*
        echo "Chat history cleared."
      fi
    else
      echo "Commit aborted."
    fi
  fi
}

# bun completions
[ -s "/Users/gersondantasdossantos/.bun/_bun" ] && source "/Users/gersondantasdossantos/.bun/_bun"

# bun
export BUN_INSTALL="$HOME/.bun"
export PATH="$BUN_INSTALL/bin:$PATH"
export GOOGLE_API_KEY="AIzaSyD_ayVPX2GxEizikmACyzM-JXujqarjUfA"

# Add ~/bin to PATH for global scripts
export PATH="$HOME/bin:$PATH"

# Google AI Chat aliases (now using global scripts)
alias gai='~/bin/gai.js'
alias gai-chat='~/bin/gai-chat.js'

eval "$(starship init zsh)" 

export PATH="/opt/homebrew/opt/postgresql@17/bin:$PATH"
export LANG="pt_BR.UTF-8"
export LC_ALL="pt_BR.UTF-8"
