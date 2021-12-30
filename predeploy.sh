echo "[pre:deploy] start"

# cd ..

rm ./output.current.tar

ls -al

docker build --no-cache -t nextjs-runner .

docker images

currentOutput=output-$RANDOM.tar

docker save -o $currentOutput nextjs-runner

cp $currentOutput ./output.current.tar
mv $currentOutput ./output.backup

ls -al

echo "[pre:deploy] done"
