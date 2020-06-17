build:
	docker build -t math-homeworks .

start: 
	docker run --rm --name math-homeworks -it -p 1000:1000 -p 2000:2000 -p 3000:3000 -d math-homeworks

stop:
	docker stop math-homeworks

clean:
	docker kill math-homeworks
	docker rm math-homeworks
