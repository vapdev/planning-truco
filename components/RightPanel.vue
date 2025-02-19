<template>
    <div
        class="justify-between h-full overflow-x-hidden bg-[#f9f9f9] dark:bg-[#191a1b] transition-all sm:max-w-[480px] w-full sm:relative absolute top-0 right-0 z-50">
        <div class="absolute top-0 right-0 min-w-full px-6 py-5">
            <div class="flex justify-between">
                <div>
                    <div class="text-xl font-semibold">Issues</div>
                    <div class="text-sm">{{ issues.length }} issues • {{ issuesTotalPoints }} points</div>
                </div>
                <div @click="$emit('close')"
                    class="block sm:hidden cursor-pointer text-2xl text-gray-500 dark:text-white">
                    X
                </div>
            </div>

            <div class="mt-6 flex flex-col gap-4 flex-grow overflow-x-hidden text-nowrap">
                <draggable class="dragArea list-group w-full" :list="issues" @change="changeDraggable">
                    <div v-for="(issue, i) in issues" :key="issue.id"
                        class="bg-[#eeeeee] dark:bg-[#292b2e] hover:scale-y-105 rounded-lg flex flex-col justify-between py-2 px-4 mb-4">
                        <div class="flex justify-between">
                            <div class="text-sm text-primary-500">#{{ i + 1 }}</div>
                            <div class="text-sm">Points</div>
                        </div>
                        <div class="flex justify-between">
                            <div class="font-semibold">{{ issue.title }}</div>
                            <div class="font-semibold">{{ issue.points }}</div>
                        </div>
                        <div>
                            <a target="_blank" :href="issue.link" v-if="issue.link"
                                class="text-sm text-blue-500 underline">{{
                                    issue.link }}</a>
                        </div>
                        <div v-if="issue.description" class="text-sm">{{ issue.description }}</div>
                    </div>
                </draggable>

                <UAccordion class="text-white" open-icon="i-heroicons-plus" close-icon="i-heroicons-minus"
                    :items="[{ label: 'Add issue', defaultOpen: true, variant: 'solid', color: 'primary' }]">
                    <template #add-issue>
                        <div class="text-gray-900 dark:text-white text-center">

                            <p class="text-sm text-gray-500 dark:text-gray-400 mt-2">
                                Fully styled and customizable components for Nuxt.
                            </p>
                        </div>
                    </template>
                    <template #item="{ item }">
                        <div class="bg-[#eeeeee] dark:bg-[#292b2e] rounded-md flex flex-col justify-between py-2 px-2">
                            <UInput color="gray" variant="outline" v-model="title" class="rounded-lg mb-2"
                                placeholder="Issue title" />
                            <UInput color="gray" variant="outline" v-model="description" class="rounded-lg mb-2"
                                placeholder="Issue description" />
                            <UInput color="gray" variant="outline" v-model="link" class="rounded-lg"
                                placeholder="Issue link" />
                            <div class="flex justify-between mt-4">
                                <UButton variant="ghost" class="text-gray-800 dark:text-white px-4 py-2 rounded-lg">
                                    Clean
                                </UButton>
                                <UButton @click="handleAddIssue" color="primary"
                                    class="text-gray-800 dark:text-white px-4 py-2 rounded-lg">Confirm</UButton>
                            </div>
                        </div>
                    </template>
                </UAccordion>
            </div>
        </div>

    </div>
</template>
<script setup>
import { VueDraggableNext as draggable } from 'vue-draggable-next'

const userStore = useUserStore();
const { issues } = storeToRefs(userStore);
const title = ref("");
const description = ref("");
const link = ref("");


const issuesTotalPoints = computed(() => issues.value.reduce((acc, issue) => acc + issue.points, 0));

const handleAddIssue = () => {
    const obj = { title: title.value, description: description.value, link: link.value };
    title.value = "";
    description.value = "";
    link.value = "";
    userStore.ws.send(JSON.stringify({ type: "newIssue", roomUUID: userStore.roomUUID, issue: obj }));
};


function changeDraggable() {
    userStore.ws.send(JSON.stringify({ type: "issueOrder", roomUUID: userStore.roomUUID, issues: issues.value.map((issue) => issue.uuid) }));
}


</script>

<style></style>