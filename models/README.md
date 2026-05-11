# In case of bug

ollama show --modelfile <model name> | cat > Modelfile
nano ./Modelfile
# There will be 2 lines of "FROM /root/.ollama/models/blobs/....",
# just add "# " in front of the 2nd "FROM"
ollama create -f ./Modelfile <name of the model>