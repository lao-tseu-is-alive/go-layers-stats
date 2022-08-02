<script setup>
import { onMounted, ref } from "vue";
import Button from "primevue/button";
import DataTable from "primevue/datatable";
import Column from "primevue/column";

const count = ref(0);
const loading = ref(true);
const data = ref([{
  "layer": "altimetrie_courbes_niveau_msgroup",
  "requests_gc_internal": 17,
  "visits_gc_internal": 5,
  "requests_gc_public": 71,
  "visits_gc_public": 14
}]);
const error = ref(null);

function fetchLayersData() {
  console.log("## entering in fetchLayersData");
  loading.value = true;
  const url = "/layers_stats.json";
  return fetch(url, {
    method: "get",
    headers: {
      "content-type": "application/json",
    },
  })
    .then((response) => {
      if (!response.ok) {
        console.log(`# PROBLEM in fetchLayersData doing fetch ${url}: http status ${response.status}`);
        const error = new Error(response.statusText);
        error.json = response.json();
        throw error;
      }
      console.log(`# in fetchLayersData after fetch ${url}: http status ${response.status}`);
      return response.json();
    })
    .then((json) => {
      console.log(`# in fetchLayersData after json() ${typeof json}`, json);
      if (json instanceof Array) {
        data.value = json;
      } else {
        error.value = "# in fetchLayersData json is not an instanceof Array"
      }
    })
    .catch((err) => {
      console.log(`# in fetchLayersData catch error :  ${err}`);
      error.value = err;
      // In case a custom JSON error response was provided
      if (err.json) {
        return err.json.then((json) => {
          // set the JSON response message
          error.value.message = json.message;
        });
      }
    })
    .then(() => {
      loading.value = false;
    });
}
onMounted(() => {
  console.log("## entering in onMounted");
  fetchLayersData();

});

defineProps({
  msg: {
    type: String,
    required: true,
  },
});
</script>

<template>
  <div class="card">
    <h3 class="green">{{ msg }}</h3>
<!--    <Button
      @click="count++"
      label="Click Me"
      icon="pi pi-plus"
      class="p-button-info p-button-icon-left p-button-rounded"
    />
    {{ count }} Times
    -->
    <DataTable :value="data" removableSort responsiveLayout="scroll">
      <Column field="layer" header="Couche" :sortable="true"/>
      <Column field="requests_gc_internal" header="hits" :sortable="true"/>
      <Column field="visits_gc_internal" header="visitors" :sortable="true"/>
      <Column field="requests_gc_public" header="hits_public" :sortable="true"/>
      <Column field="visits_gc_public" header="visitors_public" :sortable="true"/>
    </DataTable>
  </div>
</template>

<style scoped></style>
