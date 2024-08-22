package main

import (
	"context"
	"fmt"
	"log"

	"golang.org/x/sync/errgroup"
)

var defaultWorkerCount = 4

func worker(
	ctx context.Context,
	workerID int,
	ch chan int,
) error {
	log.Printf("worker started: %d\n", workerID)

	for {
		select {
		case <-ctx.Done():
			log.Printf("worker received Done: %d\n", workerID)
			return ctx.Err()
		case w, ok := <-ch:
			if !ok {
				log.Printf("worker ran out of work: %d\n", workerID)
				return nil
			}

			fmt.Printf("worked on: %d\n", w)
			// return fmt.Errorf("")
		}
	}
}

func run(ctx context.Context) error {
	ch := make(chan int)
	eg, ctx := errgroup.WithContext(context.Background())
	for i := 0; i < defaultWorkerCount; i++ {
		workerID := i
		eg.Go(func() error {
			return worker(
				ctx,
				workerID,
				ch,
			)
		})
		log.Printf("spawned worker: %d\n", workerID)
	}

	work := make([]int, 1000)
	for i := 0; i < 1000; i++ {
		work[i] = i
	}
	eg.Go(func() error {
		log.Printf("spawned distributor\n")
		defer close(ch)
		for i, w := range work {
			select {
			case <-ctx.Done():
				fmt.Println("distributor get ctx.Done()")
				return ctx.Err()
			case ch <- w:
			}

			if i > 0 && i%100 == 0 {
				log.Printf("main thread has distributed %d rows\n", i)
			}
		}

		log.Printf("distributor done\n")
		return nil
	})

	log.Printf("main thread calling eg.Wait\n")
	if err := eg.Wait(); err != nil {
		return err
	}
	log.Printf("main thread pass eg.Wait\n")

	return nil
}

func main() {
	ctx := context.Background()
	if err := run(ctx); err != nil {
		panic(err)
	}
}
