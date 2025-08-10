#!/bin/bash

ASK_MODEL="qwen3:4b-terminal"
MODEL_MAX_TOKENS=40960
MAX_SAFE_PROMPT_TOKENS=36000

if [ "$1" == "/stop" ]; then
    ollama stop $ASK_MODEL
    echo "Stopped $ASK_MODEL"
else
    # Init chat history if needed
    if [ -z "$CHAT_HISTORY" ]; then
      CHAT_HISTORY=""
    fi

    # Get user input
    USER_INPUT="$*"

    # Add user message
    CHAT_HISTORY="$CHAT_HISTORY
    user: \"$USER_INPUT\""

    # Estimate token usage
    CHAR_COUNT=$(echo "$CHAT_HISTORY" | wc -m)
    EST_TOKENS=$((CHAR_COUNT / 4))

    echo "Tokens used: $EST_TOKENS / $MODEL_MAX_TOKENS"

    # Trim if needed
    if [ "$EST_TOKENS" -gt "$MAX_SAFE_PROMPT_TOKENS" ]; then
      echo "Trimming history..."
      CHAT_HISTORY=$(echo "$CHAT_HISTORY" | tail -n 20)
      CHAT_HISTORY="(Earlier conversation trimmed)\n$CHAT_HISTORY"
      CHAR_COUNT=$(echo "$CHAT_HISTORY" | wc -m)
      EST_TOKENS=$((CHAR_COUNT / 4))
      echo "Tokens after trim: $EST_TOKENS"
    fi

    # Call model
    AI_OUTPUT=$(ollama run $ASK_MODEL --think=0 "$CHAT_HISTORY")

    # Show reply
    echo "$AI_OUTPUT"

    # Add reply to history
    CHAT_HISTORY="$CHAT_HISTORY
    ai: \"$AI_OUTPUT\""

    export CHAT_HISTORY
fi
