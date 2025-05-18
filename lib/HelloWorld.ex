#
# This file is part of AtomVM.
#
# Copyright 2018 Davide Bettio <davide@uninstall.it>
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#    http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#
# SPDX-License-Identifier: Apache-2.0 OR LGPL-2.1-or-later
#

defmodule HelloWorld do
  def start() do
    :io.format(~c"Hello World~n")

    _sta_result =
      :network.wait_for_sta(
        [
          ssid: "HALNy-2.4G-0bbb82",
          psk: "u88WHuLc8u"
        ],
        15_000
      )

    wait_for_network()

    # IO.puts("Sleeping for 15 seconds to stabilize network connection...")

    # :timer.sleep(15_000)

    # :ssl.start()

    # IO.puts("Attempting to connect...")

    # {:ok, conn1} =
    #   :ahttp_client.connect(:https, ~c"curiosum.com", 443,
    #     verify: :verify_none,
    #     active: false
    #   )

    # IO.inspect("HTTP connection result:")
    # IO.inspect(conn1)

    # {:ok, conn2, _ref} =
    #   :ahttp_client.request(conn1, "GET", "/", [], nil)

    # IO.inspect("HTTP request result:")
    # IO.inspect(conn2)

    # {:ok, _conn3, response} =
    #   :ahttp_client.recv(conn2, 0)

    # response
    # |> Enum.each(fn
    #   {:data, _, v} ->
    #     IO.puts("Data key: #{v}\n")

    #   {:header, _, v} ->
    #     IO.puts("Header: #{v |> inspect()}\n")

    #   other ->
    #     IO.puts("Other: #{other |> inspect()}\n")
    # end)

    # loop()
  end

  defp wait_for_network do
    receive do
      :disconnected ->
        IO.puts("Disconnected from network")
        wait_for_network()

      :connected ->
        IO.puts("Connected to network")
        wait_for_network()

      {:ok, {ip, _mask, _gateway}} ->
        IO.puts("Got IP: #{inspect(ip)}")
        wait_for_network()

      msg ->
        IO.puts("Received: #{msg |> inspect()} \n")
        wait_for_network()
    after
      10_000 ->
        IO.puts("Timeout waiting for network connection")
    end
  end

  # defp loop do
  #   :io.format(~c"Inside loop...")
  #   :timer.sleep(2000)

  #   loop()
  # end
end
